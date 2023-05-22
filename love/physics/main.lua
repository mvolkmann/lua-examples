local colors = require "colors"
local love = require "love"

local g = love.graphics
-- From the docs, "This module is essentially just a binding to Box2D."
-- Also see breezefield (https://github.com/HDictus/breezefield)
-- which purports to be easier to use.
local p = love.physics

local boxSize = 50
local metersPerPixel = 32

local windowWidth, windowHeight = g.getDimensions()

local boxes = {}

-- ----------------------------------------------------------------------------

function addBox()
  local x = math.random(0, windowWidth - boxSize)
  local box = { x = x, y = 0, width = boxSize, height = boxSize }
  box.body = p.newBody(world, box.x, box.y, "dynamic")
  box.shape = p.newRectangleShape(box.width, box.height)
  box.fixture = p.newFixture(box.body, box.shape, 1)
  box.fixture:setRestitution(0.3)
  table.insert(boxes, box)
end

-- ----------------------------------------------------------------------------

function love.load()
  math.randomseed(os.time())

  p.setMeter(metersPerPixel)
  world = p.newWorld(0, 9.81 * metersPerPixel, true)

  local groundHeight = 30
  ground = {
    x = 0,
    y = windowHeight - groundHeight,
    width = windowWidth,
    height = groundHeight
  }
  ground.body = p.newBody(world, ground.x, ground.y, "static")
  ground.shape = p.newRectangleShape(ground.width, ground.height)
  ground.fixture = p.newFixture(ground.body, ground.shape, 1)
end

-- dt is "delta time" which is the seconds since the last call.
-- This is typically much less than one second.
function love.update(dt)
  world:update(dt)
end

function love.draw()
  -- Draw the ground.
  g.setColor(colors.green)
  g.rectangle(
    "fill",
    ground.body:getX(), ground.body:getY(),
    ground.width, ground.height
  )

  -- Draw all the boxes.
  g.setColor(colors.red)
  for _, box in ipairs(boxes) do
    g.rectangle("fill", box.body:getX(), box.body:getY(), box.width, box.height)
  end
end

function love.keypressed(k)
  if k == "escape" then
    love.event.quit("restart")
  elseif k == "b" then
    addBox()
  end
end
