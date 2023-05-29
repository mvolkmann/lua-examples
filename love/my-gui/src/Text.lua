local colors = require "colors"
local love = require "love"
require "util"

local g = love.graphics
local padding = 0

local mt = {
  __index = {
    color = colors.white,
    draw = function(self)
      g.setColor(self.color)
      if self.x and self.y then
        g.setFont(self.font)
        g.print(self.text, self.x + padding, self.y + padding)
        if self.debug then
          g.setColor(colors.red)
          g.rectangle("line", self.x, self.y, self.width, self.height)
        end
      end
    end
  }
}

function Text(text, options)
  local t = type(options)
  assert(t == "table" or t == "nil", "Text options must be a table.")

  if not text then
    error("Text requires text")
  end

  instance = options or {}
  instance.text = text

  local font = instance.font or g.getFont()
  instance.font = font

  local textWidth = font:getWidth(text)
  local textHeight = font:getHeight()
  instance.width = textWidth + padding * 2
  instance.height = textHeight + padding * 2

  setmetatable(instance, mt)

  return instance
end

return Text
