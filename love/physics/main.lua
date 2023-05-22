local Button = require "button"
local colors = require "colors"
local love = require "love"

local g = love.graphics
-- From the docs, "This module is essentially just a binding to Box2D."
-- Also see breezefield (https://github.com/HDictus/breezefield)
-- which purports to be easier to use.
local p = love.physics

local pixelsPerMeter = 64
local boxes = {}

-- These variables are set in love.load.
local buttonFont, dropButton, windowWidth, windowHeight

-- ----------------------------------------------------------------------------

function addBox()
  local size = 50
  local halfSize = size / 2
  local boxCenterX = math.random(halfSize, windowWidth - halfSize)
  local boxCenterY = halfSize

  local box = {}
  box.color = randomColor()
  box.body = p.newBody(world, boxCenterX, boxCenterY, "dynamic")
  box.shape = p.newRectangleShape(size, size)
  -- local density = 2 -- 1
  box.fixture = p.newFixture(box.body, box.shape)
  box.fixture:setRestitution(0.3)
  table.insert(boxes, box)
end

-- ----------------------------------------------------------------------------

function love.load()
  math.randomseed(os.time())

  p.setMeter(pixelsPerMeter)
  local xGravity = 0
  local yGravity = 9.81 * pixelsPerMeter
  world = p.newWorld(xGravity, yGravity)

  windowWidth, windowHeight = g.getDimensions()

  local groundHeight = 30
  local groundCenterX = windowWidth / 2
  local groundCenterY = windowHeight - groundHeight / 2

  ground = {}
  ground.body = p.newBody(world, groundCenterX, groundCenterY, "static")
  ground.shape = p.newRectangleShape(windowWidth, groundHeight)
  ground.fixture = p.newFixture(ground.body, ground.shape)

  buttonFont = g.newFont(30)
  dropButton = Button.new({
    font = buttonFont,
    text = "Drop Box",
    x = 120,
    y = 70,
    onclick = addBox
  })
end

-- dt is "delta time" which is the seconds since the last call.
-- This is typically much less than one second.
function love.update(dt)
  world:update(dt)
end

function love.draw()
  -- Draw the ground.
  g.setColor(colors.green)
  print("points =", ground.shape:getPoints())
  print("worldPoints =", ground.body:getWorldPoints(ground.shape:getPoints()))
  love.graphics.polygon(
    "fill",
    ground.body:getWorldPoints(
      ground.shape:getPoints()
    )
  )

  -- Draw all the boxes.
  for _, box in ipairs(boxes) do
    g.setColor(box.color)
    -- Must draw a polygon, not a rectangle, in order to
    -- allow the shapes to rotate when they collide.
    g.polygon(
      "fill",
      box.body:getWorldPoints( -- returns multiple x,y values
        box.shape:getPoints()  -- returns multiple x,y values
      )
    )
  end

  g.setFont(buttonFont)
  dropButton:draw()
end

function love.keypressed(k)
  if k == "escape" then
    love.event.quit("restart")
  elseif k == "b" then
    addBox()
  end
end

function love.mousepressed(x, y, button)
  if button ~= 1 then return end -- check for left mouse button

  dropButton:handleClick(x, y)
end
