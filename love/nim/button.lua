local colors = require "colors"
local love = require "love"

local M = {}

local g = love.graphics
local padding = 10

local mt = {
  __index = {
    draw = function(self)
      local cornerRadius = padding
      g.setColor(self.buttonColor)
      g.rectangle(
        "fill",
        self.x, self.y,
        self.width, self.height,
        cornerRadius, cornerRadius
      )
      g.setColor(self.textColor)
      g.print(self.text, self.x + padding, self.y + padding, 0)
    end,
    handleClick = function(self, x, y)
      local clicked = x >= self.x and
          x <= self.x + self.width and
          y >= self.y and
          y <= self.y + self.height
      if clicked then self.callback() end
    end
  }
}

function M.new(opt)
  if not opt.text then
    error("Button requires text")
  end

  local font = opt.font or g.getFont()
  opt.font = font
  local textWidth = font:getWidth(opt.text)
  local textHeight = font:getHeight()
  opt.width = textWidth + padding * 2
  opt.height = textHeight + padding * 2

  opt.textColor = opt.textColor or colors.black
  opt.buttonColor = opt.buttonColor or colors.gray

  setmetatable(opt, mt)

  return opt
end

return M
