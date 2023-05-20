local love = require "love"
local Button = require "button"
local colors = require "colors"
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

function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      s = s .. k .. ' = ' .. dump(v) .. ', '
    end
    return s .. '} '
  else
    return tostring(o)
  end
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
  print("logoOptions =", dump(logoOptions))

  degreeInRadians = math.pi / 180

  math.randomseed(os.time())
  dice = math.random(6)

  g.setBackgroundColor(colors.green2)

  buttons = {
    Button.new({
      text = "Press Me",
      x = 50,
      y = 200,
      callback = function()
        love.audio.play(sound)
        dice = math.random(6)
      end
    })
  }
end

function love.draw()
  drawImage(logo, logoOptions)
  setFont(fonts.s36)
  drawText(dice, { x = 200, y = 200 })
  setFont(fonts.s18)

  for _, b in ipairs(buttons) do
    b:draw()
  end
  setColor(colors.white)

  -- Display a button that can be clicked.
end

function love.keypressed(k)
  if k == "escape" then love.event.quit("restart") end
end

function love.mousepressed(x, y, button)
  if button == 1 then -- left mouse button
    for _, b in ipairs(buttons) do
      b:handleClick(x, y)
    end
  end

  -- This will not play again until the currently playing sound completes.
end

function love.update(dt)
  logoOptions.angle = (logoOptions.angle + degreeInRadians) % (math.pi * 2)
end
