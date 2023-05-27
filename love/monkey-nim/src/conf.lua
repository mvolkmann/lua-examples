local love = require "love"

function love.conf(t)
  t.modules.joystick = false
  t.title = "Monkey Nim"
  t.version = "11.4" -- version of Love2D
  -- When t.window.width and t.window.height are not set,
  -- love.graphics.getDimensions() returns the screen width and height.
end
