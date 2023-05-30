local colors = require "colors"
local love = require "love"

local g = love.graphics
local padding = 10

local mt = {
  __index = {
    draw = function(self, parentX, parentY)
      local cornerRadius = padding
      g.setColor(self.buttonColor)
      local x = parentX + self.x
      local y = parentY + self.y
      self.actualX = x
      self.actualY = y
      g.rectangle(
        "fill", x, y, self:getWidth(), self:getHeight(),
        cornerRadius, cornerRadius
      )
      g.setColor(self.labelColor)
      g.setFont(self.font)
      g.print(self.label, x + padding, y + padding)
    end,

    getHeight = function(self)
      local labelHeight = self.font:getHeight()
      return labelHeight + padding * 2
    end,

    getWidth = function(self)
      local labelWidth = self.font:getWidth(self.label)
      return labelWidth + padding * 2
    end,

    handleClick = function(self, clickX, clickY)
      local x = self.actualX
      local y = self.actualY
      local width = self:getWidth()
      local height = self:getHeight()
      local clicked = x <= clickX and clickX <= x + width and
          y <= clickY and clickY <= y + height
      if clicked then self.onClick() end
      return clicked
    end
  }
}

-- Supported options are:
-- buttonColor: background color of button; defaults to white
-- font: font used for button label
-- labelColor: color of label; defaults to black
-- onClick: function called when button is clicked
function Button(label, options)
  options = options or {}
  local t = type(options)
  assert(t == "table", "Button options must be a table.")

  local font = options.font or g.getFont()

  local instance = options
  instance.kind = "Button"
  instance.font = font
  instance.label = label
  instance.labelColor = instance.labelColor or colors.black
  instance.buttonColor = instance.buttonColor or colors.white

  setmetatable(instance, mt)

  return instance
end

return Button
