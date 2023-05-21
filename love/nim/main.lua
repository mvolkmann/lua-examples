local love = require "love"
local Button = require "button"
local colors = require "colors"
local util = require "util"

local g = love.graphics

function drawImage(image, opt)
  local x = opt.x or 0
  local y = opt.y or 0
  local angle = opt.angle or 0
  local centerX = opt.width / 2
  local centerY = opt.height / 2
  g.draw(image, x + centerX, y + centerY, angle, 1, 1, centerX, centerY)
end

function drawText(text, opt)
  local x = opt.x or 0
  local y = opt.y or 0
  local angle = opt.angle or 0
  local scale = opt.scale or 1
  g.print(text, x, y, angle, scale)
end

function gradient(colors)
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

function setColor(color) g.setColor(color) end

function setFont(font) g.setFont(font) end

-- ----------------------------------------------------------------------------

function love.load()
  fonts = {
    s18 = g.newFont(18),
    s36 = g.newFont(36)
  }

  setColor(colors.white) -- initial
  setFont(fonts.s18)     -- initial

  sound = love.audio.newSource("sounds/click.wav", "stream")

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
      text = "Press Me",
      x = 50,
      y = 200,
      callback = function()
        -- This will not play again until the currently playing sound completes.
        love.audio.play(sound)
        dice = math.random(6)
      end
    })
  }

  shapes = {
    {
      type = "rectangle",
      x = 300,
      y = 200,
      width = 100,
      height = 50,
      color = colors.red
    },
    {
      type = "rectangle",
      x = 400,
      y = 400,
      width = 50,
      height = 150,
      color = colors.blue
    }
  }

  grad = gradient({ colors.red, colors.blue })

  dragging, dragX, dragY = nil, 0, 0

  g.setBackgroundColor(colors.green2)
end

function love.draw()
  drawImage(logo, logoOptions)
  setFont(fonts.s36)
  drawText(dice, { x = 200, y = 200 })
  setFont(fonts.s18)

  for _, button in ipairs(buttons) do
    button:draw()
  end

  for _, shape in ipairs(shapes) do
    if shape.type == "rectangle" then
      setColor(shape.color)
      g.rectangle("fill", shape.x, shape.y, shape.width, shape.height)
    end
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
  if button ~= 1 then return end -- left mouse button

  for _, button in ipairs(buttons) do
    button:handleClick(x, y)
  end

  for _, shape in ipairs(shapes) do
    if shape.x <= x and x <= shape.x + shape.width and
        shape.y <= y and y <= shape.y + shape.height then
      dragging, dragX, dragY = shape, x, y
    end
  end
end

function love.mousereleased(x, y, button)
  if button ~= 1 then return end -- left mouse button

  dragging = nil
end

function love.update(dt)
  logoOptions.angle = (logoOptions.angle + degreeInRadians) % (math.pi * 2)

  if dragging then
    local newX = love.mouse.getX()
    local newY = love.mouse.getY()
    dragging.x = dragging.x + newX - dragX
    dragging.y = dragging.y + newY - dragY
    dragX, dragY = newX, newY
  end
end
