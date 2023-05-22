local love = require "love"

function love.conf(t)
  t.title = "LOVE Demo"
  t.version = "11.4"     -- version of Love2D
  t.window.width = 590   -- half of 1179 (iPhone 14 Pro width)
  t.window.height = 1276 -- half of 2556 (iPhone 14 Pro height)
  t.window.resizable = false
end
