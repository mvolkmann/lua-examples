local love = require "love"

function love.conf(t)
  t.modules.joystick = false
  t.title = "Monkey Nim"
  t.version = "11.4"    -- version of Love2D
  t.window.width = 393  -- third of 1179 (iPhone 14 Pro width)
  t.window.height = 852 -- third of 2556 (iPhone 14 Pro height)
end
