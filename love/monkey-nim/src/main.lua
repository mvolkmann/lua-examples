local Button = require "button"
local colors = require "colors"
local fun = require "fun"
local love = require "love"
-- local lurker = require "lurker"
local nim = require "nim"
require "point-within-shape"
require "util"

-- Variables that are set once and never change
-- can be set at the top level, outside of the "love.load" function.
-- Variables that need to be reset when a new game is started
-- should be set in the "love.load" function.

math.randomseed(os.time())

local g = love.graphics
local p = love.physics

local backgroundImage = love.graphics.newImage("images/background.jpg")
local backgroundSpeed = 20
local bananaImage = g.newImage('images/banana.png')
local bananaDx = bananaImage:getWidth() / 2
local bananaDy = bananaImage:getHeight() / 2
local boxSize = 50
local branchHeight = 90
local collisionSound = love.audio.newSource("sounds/monkey.ogg", "static")
local handImage = g.newImage('images/hand.png')
local monkeyImage = g.newImage('images/monkey.png')
local pixelsPerMeter = 64
local wallWidth = 6
local windowWidth, windowHeight = g.getDimensions()

local fonts = {
  default = g.newFont("Pangolin-Regular.ttf", 18),
  button = g.newFont("Pangolin-Regular.ttf", 30)
}

-- These variables are set in love.load.
local backgroundPosition, boxData, boxes, buttons, ceiling
local computerFirstButton, computerMoving, gameResult
local monkeyPosition, playerFirstButton, ropes

local keyMap = {
  left = function() dec(monkeyPosition, "x") end,
  right = function() inc(monkeyPosition, "x") end,
  up = function() dec(monkeyPosition, "y") end,
  down = function() inc(monkeyPosition, "y") end
}

-- lurker.postswap = love.load

-- ----------------------------------------------------------------------------

function beginContact()
  -- We need to copy the sound in order for multiple copies
  -- to overlap playing at the same time.
  -- local clone = collisionSound:clone()
  -- clone:play()

  collisionSound:play()
end

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
    gameResult = "You lost!"
  elseif remaining == 1 then
    local box = fun.find(boxes, function(box)
      local data = boxData[box]
      return data.alive
    end)
    if box then removeBox(box) end
    gameResult = "You won!"
  end
  if gameResult then
    buttons = { computerFirstButton, playerFirstButton }
    return
  end

  -- Conditionally show the mouse cursor.
  love.mouse.setVisible(not gameResult)

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

  -- Wait for the boxes to drop before enabling the next player move.
  future(function() computerMoving = false end, 1)
end

function createBox(size, centerX, centerY)
  local box = {
    centerX = centerX,
    centerY = centerY,
    -- color = randomColor(0.5),
    color = colors.brown,
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
  local lastY = branchHeight
  for row = 1, count do
    local boxX = x + math.random(-halfSize, halfSize)
    local box = createBox(boxSize, boxX, lastY + boxSize)
    boxData[box] = { column = column, row = row, alive = true }

    local ropeEndY = box.centerY - halfSize
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

function createWorld()
  -- Configure gravity.
  p.setMeter(pixelsPerMeter)
  local xGravity = 0
  local yGravity = 9.81 * pixelsPerMeter
  local world = p.newWorld(xGravity, yGravity)

  world:setCallbacks(beginContact)

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
  rightWall.body = p.newBody(
    world,
    windowWidth - wallWidth / 2,
    wallCenterY, "static"
  )
  rightWall.shape = p.newRectangleShape(wallWidth, windowHeight)
  rightWall.fixture = p.newFixture(rightWall.body, rightWall.shape)

  local walls = { ceiling, leftWall, floor, rightWall }

  return world, walls
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

function removeBox(box)
  -- Remove the rope at the top of this box.
  local rope = ropes[box]
  ropes[box] = nil
  rope:destroy()

  -- Mark this box and all those below as no longer alive.
  local data = boxData[box]
  local column = data.column
  local row = data.row
  for _, d in pairs(boxData) do
    if d.column == column and d.row >= row then
      d.alive = false
    end
  end
end

function showFPS()
  g.setColor(colors.white)
  g.setFont(fonts.default)
  g.print("FPS:" .. love.timer.getFPS(), 10, windowHeight - 25)
end

-- ----------------------------------------------------------------------------

function love.load()
  backgroundPosition = 0
  boxData = {}
  boxes = {}
  buttons = {}
  computerMoving = false
  gameResult = nil
  ropes = {}

  world, walls = createWorld()

  monkeyPosition = { x = 10, y = 300 }

  createColumn(1, 3, windowWidth * 0.2)
  createColumn(2, 5, windowWidth * 0.5)
  createColumn(3, 7, windowWidth * 0.8)

  -- The buttons must be defined after "love.load" is defined.
  computerFirstButton = Button.new({
    font = fonts.button,
    text = "You go first",
    x = 100,
    y = 230,
    onclick = function()
      love.load()
      computerMove()
    end
  })
  playerFirstButton = Button.new({
    font = fonts.button,
    text = "Let me go first",
    x = 100,
    y = 150,
    onclick = love.load
  })

  -- Hide the mouse cursor.
  love.mouse.setVisible(false)
end

-- dt is "delta time" which is the seconds since the last call.
-- This is typically much less than one second.
function love.update(dt)
  processFutures()

  backgroundPosition = (backgroundPosition - backgroundSpeed * dt) % windowWidth

  world:update(dt)
  -- lurker.update()

  -- Process keys being held down.
  for key, fn in pairs(keyMap) do
    if love.keyboard.isDown(key) then fn() end
  end
end

function love.draw()
  -- Draw the background image.
  g.draw(backgroundImage, backgroundPosition, 0)
  g.draw(backgroundImage, backgroundPosition - windowWidth, 0)

  -- Draw the branch across the top.
  g.setColor(colors.brown)
  g.rectangle("fill", 0, 0, windowWidth, branchHeight)
  g.setColor(colors.white)
  g.setFont(fonts.button)
  g.print("Don't take the last banana!", 26, branchHeight - 40)

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
  g.setLineWidth(8)
  g.setColor(colors.brown)
  for _, rope in pairs(ropes) do
    g.line(rope:getAnchors())
  end

  -- Draw all the boxes.
  g.setLineWidth(2)
  for _, b in ipairs(boxes) do
    g.setColor(b.color or colors.white)

    -- We must draw a polygon, not a rectangle, in order to
    -- allow the boxes to rotate when they collide.
    local points = { getShapePoints(b) }
    g.polygon("line", unpack(points))

    local centerX, centerY = getCenter(points)
    g.setColor(colors.white)
    -- g.circle("fill", centerX, centerY, 3)
    g.draw(bananaImage, centerX - bananaDx, centerY - bananaDy)
  end

  if gameResult then
    g.setColor(colors.white)
    g.setFont(fonts.button)
    g.print(gameResult, 100, 100)

    -- Draw all the buttons.
    g.setFont(fonts.button)
    for _, button in ipairs(buttons) do
      button:draw()
    end
  end

  showFPS()

  -- g.draw(monkeyImage, monkeyPosition.x, monkeyPosition.y)

  if not computerMoving then
    -- If the cursor is in the window ...
    local x, y = love.mouse.getPosition()
    if 0 < x and x < windowWidth - 1 and
        0 < y and y < windowHeight - 1 then
      -- Draw a monkey at the cursor position.
      local h = monkeyImage:getHeight()
      local w = monkeyImage:getWidth()
      g.draw(monkeyImage, x - w / 2, y - h / 2)
    end
  end
end

function love.mousepressed(x, y, button)
  if button ~= 1 then return end -- check for left mouse button

  -- Check for clicks on buttons.
  for _, b in ipairs(buttons) do
    local clicked = b:handleClick(x, y)
    if clicked then return end
  end
end

function love.mousereleased(x, y, button)
  if button ~= 1 then return end -- check for left mouse button

  -- Check for clicks on boxes.
  for _, box in ipairs(boxes) do
    local data = boxData[box]
    if data.alive and insideBox(x, y, box) then
      removeBox(box)
      computerMoving = true
      future(computerMove, 2)
      break
    end
  end
end
