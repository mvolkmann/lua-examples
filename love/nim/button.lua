local love = require "love"

local mt = {
  draw = function () {
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.print(text, x, y, 0)
  }
  isClicked = function()
  end,
  handle = function(x, y)
  end
}

function Button(text, x, y, callback, opt)
  local instance = {
    text = text,
    x = x,
    y = y,
    callback = callback
    opt = opt,
    height = opt.height or 100,
    width = opt.width or 100,
  }
  setmetatable(instance, mt)

  return instance
end
