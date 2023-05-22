local colors = require "colors"
local love = require "love"

local g = love.graphics
local p = love.physics

local metersPerPixel = 32

-- ----------------------------------------------------------------------------

function love.load()
  size = 50
  box = { x = 100, y = 0, width = size, height = size }

  p.setMeter(metersPerPixel)
  world = p.newWorld(0, 9.81 * metersPerPixel, true)
  box.body = p.newBody(world, box.x, box.y, "dynamic")
  box.shape = p.newRectangleShape(box.width, box.height)
  box.fixture = p.newFixture(box.body, box.shape, 1)
  box.fixture:setRestitution(0.3)

  local width, height = g.getDimensions()
  ground = { x = 0, y = height - 30, width = width, height = 30 }
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
  g.setColor(colors.red)
  g.rectangle("fill", box.body:getX(), box.body:getY(), box.width, box.height)
  g.setColor(colors.green)
  g.rectangle(
    "fill",
    ground.body:getX(), ground.body:getY(),
    ground.width, ground.height
  )
end

function love.keypressed(k)
  if k == "escape" then love.event.quit("restart") end
end
