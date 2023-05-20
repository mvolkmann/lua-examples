local love = require "love"

function drawImage(image, opt)
  local x = opt.x or 0
  local y = opt.y or 0
  local angle = opt.angle or 0
  local scale = opt.scale or 1
  love.graphics.draw(image, x, y, angle, scale)
end

function drawText(text, opt)
  local x = opt.x or 0
  local y = opt.y or 0
  local angle = opt.angle or 0
  local scale = opt.scale or 1
  love.graphics.print(text, x, y, angle, scale)
end

function rgb(red, green, blue)
  return red / 255, green / 255, blue / 255
end

function setColor(color)
  love.graphics.setColor(color)
end

function setFont(font)
  love.graphics.setFont(font)
end

-- ####################################

function love.load()
  colors = {
    blue = { 0, 0, 1, 1 },
    gray = { rgb(150, 150, 150) },
    green = { 0, 1, 0, 1 },
    green2 = { rgb(25, 125, 75) },
    red = { 1, 0, 0, 1 },
    white = { 1, 1, 1, 1 }
  }


  fonts = {
    s18 = love.graphics.newFont(18),
    s36 = love.graphics.newFont(36)
  }

  setColor(colors.white) -- initial
  setFont(fonts.s18)     -- initial

  sound = love.audio.newSource("sounds/click.wav", "stream")

  logo = love.graphics.newImage('images/lua.png')
  logoAngle = 0
  degreeInRadians = math.pi / 180

  math.randomseed(os.time())
  dice = math.random(6)

  love.graphics.setBackgroundColor(colors.green2)
end

function love.draw()
  drawImage(logo, { x = 200, y = 0, angle = logoAngle, scale = 0.2 })
  drawText("Hello, Love!", { x = 400, y = 300 })
  drawText(dice, { x = 400, y = 400, font = font36 })

  setColor(colors.gray)
  love.graphics.rectangle("fill", 100, 300, 100, 50)
  setColor(colors.red)
  drawText("Press Me", { x = 100, y = 300 })
  setColor(colors.white)

  -- Display a button that can be clicked.
end

function love.keypressed(k)
  if k == "escape" then love.event.quit("restart") end
end

function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 then -- left mouse button
    for b in pairs(buttons) do
      b:handle(x, y)
    end
  end

  -- This will not play again until the currently playing sound completes.
  love.audio.play(sound)
  dice = math.random(6)
end

function love.update(dt)
  logoAngle = (logoAngle + degreeInRadians) % (math.pi * 2)
end
