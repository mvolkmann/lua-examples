local love = require "love"
local Button = require "button"
local colors = require "colors"
local fonts = require "fonts"
local util = require "util"
require "shapes"

local g = love.graphics

local function drawImage(image, opt)
  local x = opt.x or 0
  local y = opt.y or 0
  local angle = opt.angle or 0
  local centerX = opt.width / 2
  local centerY = opt.height / 2
  g.draw(image, x + centerX, y + centerY, angle, 1, 1, centerX, centerY)
end

local function drawText(text, opt)
  local x = opt.x or 0
  local y = opt.y or 0
  local angle = opt.angle or 0
  local scale = opt.scale or 1
  g.print(text, x, y, angle, scale)
end

local function gradient(colors)
  local direction = colors.direction or "horizontal"
  local isHorizontal = direction == "horizontal"

  local result = love.image.newImageData(
    isHorizontal and 1 or #colors,
    isHorizontal and #colors or 1
  )

  for i, color in ipairs(colors) do
    local x, y
    if isHorizontal then
      x, y = 0, i - 1
    else
      x, y = i - 1, 0
    end
    result:setPixel(x, y, color[1], color[2], color[3], color[4] or 255)
  end

  result = love.graphics.newImage(result)
  result:setFilter('linear', 'linear')
  return result
end

local function handleMouse()
  local x = love.mouse.getX()
  local y = love.mouse.getY()

  for _, shape in ipairs(shapes) do
    shape.selected = shape:pointInside(x, y)
  end

  if not dragging then return end

  dragging.x = dragging.x + x - dragX
  dragging.y = dragging.y + y - dragY
  dragX, dragY = x, y
end

local function rotateLogo(dt)
  local twoPi = math.pi * 2
  local anglePerSecond = twoPi / 3 -- take 3 seconds for full rotation
  local deltaAngle = anglePerSecond * dt
  logoOptions.angle = (logoOptions.angle + deltaAngle) % twoPi
end

local function setColor(color) g.setColor(color) end

local function setFont(font) g.setFont(font) end

-- ----------------------------------------------------------------------------

function love.load()
  setColor(colors.white) -- initial
  setFont(fonts.s18)     -- initial

  diceSound = love.audio.newSource("sounds/dice.wav", "stream")

  -- The type of logo is "userdata".
  logo = g.newImage('images/lua-128.png')
  local width = logo:getWidth()
  local height = logo:getHeight()
  logoOptions = {
    x = 50,
    y = 30,
    width = width,
    height = height,
    angle = 0
  }
  util.dump("logoOptions", logoOptions)

  degreeInRadians = math.pi / 180

  math.randomseed(os.time())
  dice = math.random(6)

  buttons = {
    Button.new({
      text = "Roll Dice",
      x = 50,
      y = 200,
      onclick = function()
        -- This will not play again until the currently playing sound completes.
        love.audio.play(diceSound)
        dice = math.random(6)
      end
    })
  }

  shapes = {
    Rectangle.new(300, 200, 100, 50, colors.red),
    Circle.new(400, 400, 50, colors.blue)
  }

  grad = gradient({ colors.red, colors.blue })

  dragging, dragX, dragY = nil, 0, 0

  g.setBackgroundColor(colors.green2)
end

function love.draw()
  drawImage(logo, logoOptions)

  setFont(fonts.s18)
  for _, button in ipairs(buttons) do
    button:draw()
  end

  setFont(fonts.s36)
  setColor(colors.white)
  drawText(dice, { x = 170, y = 200 })

  for _, shape in ipairs(shapes) do
    shape:draw()
  end

  setColor(colors.white)

  -- TODO: Why doesn't this display anything?
  -- See https://love2d.org/wiki/Gradients.
  drawImage(grad, {
    x = 0,
    y = 0,
    width = 500,
    height = 500
  })
end

function love.keypressed(k)
  if k == "escape" then love.event.quit("restart") end
end

function love.mousepressed(x, y, button)
  if button ~= 1 then return end -- check for left mouse button

  for _, button in ipairs(buttons) do
    button:handleClick(x, y)
  end

  -- Iterating in reverse to prefer shape on top.
  for i = #shapes, 1, -1 do
    local shape = shapes[i]
    if shape:pointInside(x, y) then
      dragging, dragX, dragY = shape, x, y
      dragging.selected = true
      break
    end
  end
end

function love.mousereleased(x, y, button)
  if button ~= 1 then return end -- check for left mouse button

  dragging = nil
end

function love.update(dt)
  rotateLogo(dt)
  handleMouse()
end
