local Button = require "button"
local colors = require "colors"
local love = require "love"
local lurker = require "lurker"
local nim = require "nim"
require "point-within-shape"
local util = require "util"

local g = love.graphics
-- From the docs, "This module is essentially just a binding to Box2D."
-- Also see breezefield (https://github.com/HDictus/breezefield)
-- which purports to be easier to use.
local p = love.physics

local boxSize = 50
local buttons = {}
local pixelsPerMeter = 64
local ropeCount = 0
local ropes = {}
local shapes = {}
local walls = {}
local wallWidth = 6

-- These variables are set in love.load.
local buttonFont, ceiling, collisionSound, windowWidth, windowHeight

lurker.postswap = function() love.event.quit "restart" end

-- ----------------------------------------------------------------------------

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
  table.insert(shapes, box)
  return box
end

function createColumn(x, count)
  local halfSize = boxSize / 2
  local lastShape = ceiling
  local lastX = x
  local lastY = 0
  for _ = 1, count do
    local boxX = x + math.random(-halfSize, halfSize)
    -- local boxX = x
    local box = createBox(boxSize, boxX, lastY + boxSize)
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

function getBoxBottom(box)
  local halfSize = box.size / 2
  return box.centerX, box.centerY + halfSize
end

function getBoxLeft(box)
  local halfSize = box.size / 2
  return box.centerX - halfSize, box.centerY
end

function getBoxRight(box)
  local halfSize = box.size / 2
  return box.centerX + halfSize, box.centerY
end

function getBoxTop(box)
  local halfSize = box.size / 2
  return box.centerX, box.centerY - halfSize
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
  local rope = ropes[box]
  ropes[box] = nil
  rope:destroy()
end

-- ----------------------------------------------------------------------------

function love.load()
  math.randomseed(os.time())

  collisionSound = love.audio.newSource("sounds/collision.mp3", "stream")

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

  buttonFont = g.newFont(30)
  buttons = {
    Button.new({
      font = buttonFont,
      text = "Clear",
      x = 145,
      y = 70,
      onclick = function()
        shapes = {}
        ropes = {}
      end
    })
  }

  local spacing = windowWidth / 4
  createColumn(spacing, 3)
  createColumn(spacing * 2, 5)
  createColumn(spacing * 3, 7)
end

-- dt is "delta time" which is the seconds since the last call.
-- This is typically much less than one second.
function love.update(dt)
  world:update(dt)
  lurker.update()
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

  -- Draw all the shapes.
  for _, s in ipairs(shapes) do
    g.setColor(s.color or colors.red)
    -- We must draw a polygon, not a rectangle, in order to
    -- allow the shapes to rotate when they collide.
    g.polygon("fill", getShapePoints(s))
  end

  -- Draw all the buttons.
  --[[ g.setFont(buttonFont)
  for _, button in ipairs(buttons) do
    button:draw()
  end ]]
end

function love.mousepressed(x, y, button)
  if button ~= 1 then return end -- check for left mouse button

  -- Check for clicks on buttons.
  --[[ for _, button in ipairs(buttons) do
    button:handleClick(x, y)
  end ]]
  --
  -- Check for clicks on boxes.
  for _, box in ipairs(shapes) do
    if insideBox(x, y, box) then
      removeBox(box)
    end
  end
end
