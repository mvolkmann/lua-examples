local colors = require "colors"
local fonts = require "fonts"
local love = require "love"

local g = love.graphics

local mt = {
  __index = {
    draw = function(self)
      g.setColor(colors.white)
      g.setFont(self.font)
      g.print("FPS: " .. love.timer.getFPS(), self.x, self.y)
    end
  }
}

function FPS(options)
  local font = options.font or g.getFont()
  local text = "FPS:" .. love.timer.getFPS()
  local instance = {
    font = font,
    kind = "FPS",
    text = text,
    width = font:getWidth(text),
    height = font:getHeight()
  }
  setmetatable(instance, mt)
  return instance
end

return FPS
