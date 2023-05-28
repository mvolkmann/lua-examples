local colors = require "colors"
local love = require "love"
require "util"

local M = {}

local g = love.graphics
local padding = 10

local mt = {
  __index = {
    color = colors.white,
    draw = function(self)
      dump("draw: self =", self)
      g.setColor(self.color)
      if self.x and self.y then
        g.print(self.text, self.x + padding, self.y + padding)
      end
    end
  }
}

function M.new(text, options)
  local t = type(options)
  assert(t == "table" or t == "nil", "Text options must be a table.")

  if not text then
    error("Text requires text")
  end

  options = options or {}
  options.text = text

  local font = options.font or g.getFont()
  options.font = font

  local textWidth = font:getWidth(text)
  local textHeight = font:getHeight()
  options.width = textWidth + padding * 2
  options.height = textHeight + padding * 2
  dump("options", options)

  setmetatable(options, mt)

  return options
end

return M
