local love = require "love"

-- Demonstration of love physics with a kinematic body
-- based on dynamic version: https://love2d.org/wiki/Tutorial:Physics
--
--
-- When an object is controlled by setting its position instead of applying
-- forces, it should be kinematic. But when it interacts with dynamic
-- bodies, sometimes they are sleeping and do not respond to collisions.
--
-- Possible solutions:
-- * set velocity instead of position
-- * detect collision and awaken bodies that collided
-- * disable sleeping for all bodies in the world

local objects, world
local pixelsPerMeter = 64

function love.load()
  love.physics.setMeter(pixelsPerMeter)
  -- One possibility is to prevent any bodies from sleeping. Costs
  -- performance: physics must now calculate all bodies instead of only
  -- awake ones. Change can_bodies_sleep to false and setPosition-based
  -- movement works as expected.
  local can_bodies_sleep = true
  -- create a world for the bodies to exist in with no gravity
  world = love.physics.newWorld(0, 0, can_bodies_sleep)

  objects = {}

  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, 650 / 2, 650 - 50 / 2)
  objects.ground.shape = love.physics.newRectangleShape(650, 50)
  objects.ground.fixture = love.physics.newFixture(objects.ground.body,
    objects.ground.shape)

  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 650 / 2, 650 / 2, "kinematic")
  objects.ball.shape = love.physics.newCircleShape(20)
  objects.ball.fixture = love.physics.newFixture(objects.ball.body,
    objects.ball.shape, 1)
  objects.ball.fixture:setRestitution(0.9)

  objects.block1 = {}
  objects.block1.body = love.physics.newBody(world, 200, 550, "dynamic")
  objects.block1.shape = love.physics.newRectangleShape(0, 0, 50, 100)
  objects.block1.fixture = love.physics.newFixture(objects.block1.body,
    objects.block1.shape, 5)

  objects.blocks = { objects.block1 }
  for i = 1, 5 do
    local b = {}
    b.body = love.physics.newBody(world, 200, 400, "dynamic")
    b.shape = love.physics.newRectangleShape(0, 0, 100, 50)
    b.fixture = love.physics.newFixture(b.body, b.shape, 2)
    table.insert(objects.blocks, b)
  end

  love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
  love.window.setMode(650, 650)
end

-- Unlike position, we need to set velocity even when not moving so we can go
-- back to 0 velocity.
local used_velocity = false
function love.update(dt)
  world:update(dt)

  -- provide two ways of moving the ball:
  -- * position (arrow keys)
  -- * veloctiy (wasd)
  local x, y = objects.ball.body:getPosition()
  local modified_position = false
  local speed = 100
  if love.keyboard.isDown("right") then
    modified_position = true
    x = x + speed * dt
  elseif love.keyboard.isDown("left") then
    modified_position = true
    x = x - speed * dt
  elseif love.keyboard.isDown("up") then
    modified_position = true
    y = y - speed * dt
  elseif love.keyboard.isDown("down") then
    modified_position = true
    y = y + speed * dt
  elseif love.keyboard.isDown("u") then
    -- wake Up
    -- When setting position, you can force all blocks to awaken to show how
    -- awaking bodies solves collision problems. In a real game, maybe you'd do
    -- this in a collision callback?
    for key, b in pairs(objects.blocks) do
      b.body:setAwake(true)
    end
  end

  if modified_position then
    objects.ball.body:setPosition(x, y)
    used_velocity = false
  end

  x, y = 0, 0
  speed = 5000
  if love.keyboard.isDown("d") then
    used_velocity = true
    x = speed * dt
  elseif love.keyboard.isDown("a") then
    used_velocity = true
    x = -speed * dt
  elseif love.keyboard.isDown("w") then
    used_velocity = true
    y = -speed * dt
  elseif love.keyboard.isDown("s") then
    used_velocity = true
    y = speed * dt
  end
  if used_velocity then
    objects.ball.body:setLinearVelocity(x, y)
  end

  if love.keyboard.isDown("escape") then
    love.event.quit()
  elseif love.keyboard.isDown("g") then
    -- Change gravity for fun.
    local gx, gy = world:getGravity()
    if love.keyboard.isDown("lshift", "rshift") then
      gy = math.min(gy + 0.1, 9.81 * pixelsPerMeter * 4)
    else
      gy = math.max(gy - 0.1, 0)
    end
    -- world:setGravity(gx, gy)
    world:setGravity(0, 9.81 * pixelsPerMeter)
  end
end

function love.draw()
  love.graphics.setColor(0.28, 0.63, 0.05)
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(
    objects.ground.shape:getPoints()))

  love.graphics.setColor(0.76, 0.18, 0.05)
  love.graphics.circle("fill", objects.ball.body:getX(),
    objects.ball.body:getY(), objects.ball.shape:getRadius())

  love.graphics.setColor(0.20, 0.20, 0.20)
  for key, b in pairs(objects.blocks) do
    love.graphics.polygon(
      "fill",
      b.body:getWorldPoints(
        b.shape:getPoints()))
  end

  love.graphics.setColor(1, 1, 1)
  local x, y = world:getGravity()
  love.graphics.printf(string.format("gravity: %.2f,%.2f", x, y), 0, 0, 100, "left")
  love.graphics.printf("arrow keys to move with position\nwasd to move with velocity", 0, 50, 300, "left")
  love.graphics.printf("g or G to change gravity and u to awaken blocks.", 300, 0, 350, "left")
end
