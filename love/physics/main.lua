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
local buttons = {}

-- These variables are set in love.load.
local buttonFont, collisionSound, windowWidth, windowHeight

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

function beginContact()
  -- We need to copy the sound in order for multiple copies
  -- to overlap playing at the same time.
  local clone = collisionSound:clone()
  clone:play()
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

  ground = {}
  ground.body = p.newBody(world, groundCenterX, groundCenterY, "static")
  ground.shape = p.newRectangleShape(windowWidth, groundHeight)
  ground.fixture = p.newFixture(ground.body, ground.shape)

  buttonFont = g.newFont(30)
  buttons = {
    Button.new({
      font = buttonFont,
      text = "Drop Box",
      x = 120,
      y = 70,
      onclick = addBox
    }),
    Button.new({
      font = buttonFont,
      text = "Reset",
      x = 145,
      y = 140,
      onclick = function()
        boxes = {}
      end
    })
  }
end

-- dt is "delta time" which is the seconds since the last call.
-- This is typically much less than one second.
function love.update(dt)
  world:update(dt)
end

function love.draw()
  -- Draw the ground.
  g.setColor(colors.green)
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

function love.keypressed(k)
  if k == "escape" then
    love.event.quit("restart") -- for debugging
  end
end

function love.mousepressed(x, y, button)
  if button ~= 1 then return end -- check for left mouse button

  for _, button in ipairs(buttons) do
    button:handleClick(x, y)
  end
end
