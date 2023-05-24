local Button = require "button"
local colors = require "colors"
local fun = require "fun"
local love = require "love"
local lurker = require "lurker"
local nim = require "nim"
require "point-within-shape"
require "util"

local g = love.graphics
-- From the docs, "This module is essentially just a binding to Box2D."
local p = love.physics

local boxes = {}
local boxSize = 50
local boxData = {}
local buttons = {}
local fonts = {}
local monkeyPosition = { x = 10, y = 30 }
local pixelsPerMeter = 64
local ropes = {}
local walls = {}
local wallWidth = 6

-- These variables are set in love.load.
local ceiling, collisionSound, font, gameResult, monkey
local newGameButton, secondsElapsed, windowWidth, windowHeight

local keyMap = {
  left = function() dec(monkeyPosition, "x") end,
  right = function() inc(monkeyPosition, "x") end,
  up = function() dec(monkeyPosition, "y") end,
  down = function() inc(monkeyPosition, "y") end
}

lurker.postswap = restart

-- ----------------------------------------------------------------------------

function computerMove()
  -- Get the number of boxes remaining in each column.
  local counts = { 0, 0, 0 }
  for _, box in ipairs(boxes) do
    local data = boxData[box]
    if data.alive then
      counts[data.column] = counts[data.column] + 1
    end
  end

  local remaining = fun.tableSum(counts)
  if remaining == 0 then
    gameResult = "The computer won."
  elseif remaining == 1 then
    local box = fun.find(boxes, function(box)
      local data = boxData[box]
      return data.alive
    end)
    if box then removeBox(box) end
    gameResult = "You won!"
  end
  if gameResult then
    buttons = { newGameButton }
    return
  end

  -- Determine the best move.
  local column, n = nim.getMove(counts)
  local row = counts[column] - n + 1

  -- Find the box to remove.
  local box
  for _, b in ipairs(boxes) do
    local data = boxData[b]
    if data.column == column and data.row == row then
      box = b
      break
    end
  end

  if box then removeBox(box) end
end

function beginContact()
  -- We need to copy the sound in order for multiple copies
  -- to overlap playing at the same time.
  local clone = collisionSound:clone()
  clone:play()
end

function createBox(size, centerX, centerY)
  local box = {
    centerX = centerX,
    centerY = centerY,
    color = randomColor(),
    size = size
  }
  box.body = p.newBody(world, centerX, centerY, "dynamic")
  box.shape = p.newRectangleShape(size, size)
  box.fixture = p.newFixture(box.body, box.shape)
  box.fixture:setRestitution(0.3)
  table.insert(boxes, box)
  return box
end

function createColumn(column, count, x)
  local halfSize = boxSize / 2
  local lastShape = ceiling
  local lastX = x
  local lastY = 0
  for row = 1, count do
    local boxX = x + math.random(-halfSize, halfSize)
    local box = createBox(boxSize, boxX, lastY + boxSize)
    boxData[box] = { column = column, row = row, alive = true }

    local ropeEndY = box.centerY - halfSize
    createRope(lastShape, box, lastX, lastY, boxX, ropeEndY)

    lastShape = box
    lastX = boxX
    lastY = ropeEndY + boxSize
  end
end

function createRope(from, to, x1, y1, x2, y2)
  local d = distanceBetweenPoints(x1, y1, x2, y2)
  local rope = p.newRopeJoint(from.body, to.body, x1, y1, x2, y2, d, true)

  -- Use the "to" box as the key in the ropes table.
  ropes[to] = rope
end

function distanceBetweenPoints(x1, y1, x2, y2)
  return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
end

-- See https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
function distanceToRope(x, y, rope)
  local x1, y1, x2, y2 = rope:getAnchors()
  local a = x - x1
  local b = y - y1
  local c = x2 - x1
  local d = y2 - y1

  local lenSq = c * c + d * d
  local param = -1
  if lenSq ~= 0 then
    local dot = a * c + b * d
    param = dot / lenSq
  end

  local xx, yy
  if param < 0 then
    xx, yy = x1, y1
  elseif param > 1 then
    xx, yy = x2, y2
  else
    xx = x1 + param * c
    yy = y1 + param * d
  end

  local dx = x - xx
  local dy = y - yy
  return math.sqrt(dx ^ 2 + dy ^ 2)
end

function getShapePoints(s)
  return s.body:getWorldPoints(s.shape:getPoints())
end

function insideBox(x, y, box)
  local coords = { getShapePoints(box) }
  local shape = {}
  for i = 1, #coords, 2 do
    table.insert(shape, { x = coords[i], y = coords[i + 1] })
  end
  return PointWithinShape(shape, x, y)
end

function newGame()
  boxData = {}
  boxes = {}
  buttons = {}
  gameResult = nil
  ropes = {}
  secondsElapsed = nil
end

function removeBox(box)
  -- Remove the rope at the top of this box.
  local rope = ropes[box]
  ropes[box] = nil
  rope:destroy()

  -- Mark this box and all those below as no longer alive.
  local data = boxData[box]
  local column = data.column
  local row = data.row
  for _, data in pairs(boxData) do
    if data.column == column and data.row >= row then
      data.alive = false
    end
  end
end

function restart()
  newGame()
  love.event.quit "restart"
end

function showFPS()
  g.setColor(colors.white)
  g.setFont(fonts.default)
  g.print("FPS: " .. love.timer.getFPS(), 10, 5)
end

-- ----------------------------------------------------------------------------

function love.load()
  math.randomseed(os.time())

  -- collisionSound = love.audio.newSource("sounds/collision.mp3", "stream")
  collisionSound = love.audio.newSource("sounds/monkey.mp3", "stream")
  monkey = g.newImage('images/monkey.png')

  -- Configure gravity.
  p.setMeter(pixelsPerMeter)
  local xGravity = 0
  local yGravity = 9.81 * pixelsPerMeter
  world = p.newWorld(xGravity, yGravity)

  world:setCallbacks(beginContact)

  windowWidth, windowHeight = g.getDimensions()

  local ceilingCenterX = windowWidth / 2
  local ceilingCenterY = 0

  ceiling = {}
  ceiling.body = p.newBody(world, ceilingCenterX, ceilingCenterY, "static")
  ceiling.shape = p.newRectangleShape(windowWidth, 0)
  ceiling.fixture = p.newFixture(ceiling.body, ceiling.shape)

  local floorHeight = 30
  local floorCenterX = windowWidth / 2
  local floorCenterY = windowHeight - floorHeight / 2
  local wallCenterY = windowHeight / 2

  local floor = {}
  floor.body = p.newBody(world, floorCenterX, floorCenterY, "static")
  floor.shape = p.newRectangleShape(windowWidth, floorHeight)
  floor.fixture = p.newFixture(floor.body, floor.shape)

  local leftWall = {}
  leftWall.body = p.newBody(world, wallWidth / 2, wallCenterY, "static")
  leftWall.shape = p.newRectangleShape(wallWidth, windowHeight)
  leftWall.fixture = p.newFixture(leftWall.body, leftWall.shape)

  local rightWall = {}
  rightWall.body = p.newBody(world, windowWidth - wallWidth / 2, wallCenterY, "static")
  rightWall.shape = p.newRectangleShape(wallWidth, windowHeight)
  rightWall.fixture = p.newFixture(rightWall.body, rightWall.shape)

  walls = { ceiling, leftWall, floor, rightWall }

  fonts.default = g.newFont("Pangolin-Regular.ttf", 18)
  fonts.button = g.newFont("Pangolin-Regular.ttf", 30)
  buttons = {}
  newGameButton = Button.new({
    font = fonts.button,
    text = "New Game",
    x = 110,
    y = 100,
    onclick = restart
  })

  local spacing = windowWidth / 4
  createColumn(1, 3, spacing)
  createColumn(2, 5, spacing * 2)
  createColumn(3, 7, spacing * 3)

  gameResult = nil
end

-- dt is "delta time" which is the seconds since the last call.
-- This is typically much less than one second.
function love.update(dt)
  if secondsElapsed then
    secondsElapsed = secondsElapsed + dt
    if secondsElapsed > 2 then
      secondsElapsed = nil
      computerMove()
    end
  end

  world:update(dt)
  lurker.update()

  -- Process keys being held down.
  for key, fn in pairs(keyMap) do
    if love.keyboard.isDown(key) then fn() end
  end
end

function love.draw()
  -- Draw the walls.
  g.setColor(colors.purple)
  for _, wall in ipairs(walls) do
    love.graphics.polygon(
      "fill",
      wall.body:getWorldPoints(
        wall.shape:getPoints()
      )
    )
  end

  -- Draw all the ropes.
  g.setLineWidth(5)
  g.setColor(colors.brown)
  for _, rope in pairs(ropes) do
    g.line(rope:getAnchors())
  end

  -- Draw all the boxes.
  for _, b in ipairs(boxes) do
    g.setColor(b.color or colors.white)
    -- We must draw a polygon, not a rectangle, in order to
    -- allow the boxes to rotate when they collide.
    g.polygon("fill", getShapePoints(b))
  end

  if gameResult then
    g.setColor(colors.white)
    g.setFont(fonts.button)
    g.print(gameResult, 70, 35)
    -- Draw all the buttons.
    g.setFont(fonts.button)
    for _, button in ipairs(buttons) do
      button:draw()
    end
  end

  showFPS()

  g.draw(monkey, monkeyPosition.x, monkeyPosition.y)

  -- Indicate the cursor position.
  --[[ local x, y = love.mouse.getPosition()
  g.setColor(colors.yellow)
  g.circle("fill", x, y, 10) ]]
end

function love.mousepressed(x, y, button)
  if button ~= 1 then return end -- check for left mouse button

  -- Check for clicks on buttons.
  for _, button in ipairs(buttons) do
    button:handleClick(x, y)
  end

  -- Check for clicks on boxes.
  for _, box in ipairs(boxes) do
    local data = boxData[box]
    if data.alive and insideBox(x, y, box) then
      removeBox(box)
      secondsElapsed = 0
      break
    end
  end
end
