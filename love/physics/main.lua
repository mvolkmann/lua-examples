local Button = require "button"
local colors = require "colors"
local love = require "love"
local lurker = require "lurker"
local util = require "util"

local g = love.graphics
-- From the docs, "This module is essentially just a binding to Box2D."
-- Also see breezefield (https://github.com/HDictus/breezefield)
-- which purports to be easier to use.
local p = love.physics

local buttons = {}
local pixelsPerMeter = 64
local ropes = {}
local shapes = {}
local walls = {}
local wallWidth = 6

-- These variables are set in love.load.
local buttonFont, collisionSound, windowWidth, windowHeight

lurker.postswap = function() love.event.quit "restart" end

-- ----------------------------------------------------------------------------

function addBox()
  local size = 50
  local halfSize = size / 2
  local minX = wallWidth + halfSize
  local maxX = windowWidth - wallWidth - halfSize
  local centerX = math.random(minX, maxX)
  local centerY = halfSize
  createBox(size, centerX, centerY)
end

function addPair()
  local size = 50
  local box1 = createBox(size, 100, 50)
  local box2 = createBox(size, 125, 150)
  local x1, y1 = getBoxBottom(box1)
  local x2, y2 = getBoxBottom(box2)
  local d = distance(x1, y1, x2, y2)
  local rope = p.newRopeJoint(box1.body, box2.body, x1, y1, x2, y2, d, true)
  table.insert(ropes, rope)
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
  table.insert(shapes, box)
  return box
end

function distance(x1, y1, x2, y2)
  return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
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

  local groundHeight = 30
  local groundCenterX = windowWidth / 2
  local groundCenterY = windowHeight - groundHeight / 2
  local wallCenterY = windowHeight / 2

  local ground = {}
  ground.body = p.newBody(world, groundCenterX, groundCenterY, "static")
  ground.shape = p.newRectangleShape(windowWidth, groundHeight)
  ground.fixture = p.newFixture(ground.body, ground.shape)

  local leftWall = {}
  leftWall.body = p.newBody(world, wallWidth / 2, wallCenterY, "static")
  leftWall.shape = p.newRectangleShape(wallWidth, windowHeight)
  leftWall.fixture = p.newFixture(leftWall.body, leftWall.shape)

  local rightWall = {}
  rightWall.body = p.newBody(world, windowWidth - wallWidth / 2, wallCenterY, "static")
  rightWall.shape = p.newRectangleShape(wallWidth, windowHeight)
  rightWall.fixture = p.newFixture(rightWall.body, rightWall.shape)

  walls = { leftWall, ground, rightWall }

  buttonFont = g.newFont(30)
  buttons = {
    Button.new({
      font = buttonFont,
      text = "Drop Box",
      x = 120,
      y = 70,
      onclick = addPair
      -- onclick = addBox
    }),
    Button.new({
      font = buttonFont,
      text = "Clear",
      x = 145,
      y = 140,
      onclick = function()
        shapes = {}
        ropes = {}
      end
    })
  }
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
  g.setColor(colors.yellow)
  for _, rope in ipairs(ropes) do
    g.line(rope:getAnchors())
  end

  -- Draw all the shapes.
  for _, s in ipairs(shapes) do
    -- util.dump("s.shape", s.shape)
    g.setColor(s.color or colors.red)
    -- Must draw a polygon, not a rectangle, in order to
    -- allow the shapes to rotate when they collide.
    g.polygon(
      "fill",
      s.body:getWorldPoints( -- returns multiple x,y values
        s.shape:getPoints()  -- returns multiple x,y values
      )
    )
    --[[ This is an alternate approach.
    -- Note that we must use unpack instead of table.unpack
    -- because love2d uses LuaJIT.
    local points = { box.shape:getPoints() }
    local worldPoints = { box.body:getWorldPoints(unpack(points)) }
    g.polygon("fill", worldPoints)
    --]]
  end

  g.setFont(buttonFont)
  for _, button in ipairs(buttons) do
    button:draw()
  end
end

function love.mousepressed(x, y, button)
  if button ~= 1 then return end -- check for left mouse button

  for _, button in ipairs(buttons) do
    button:handleClick(x, y)
  end
end
