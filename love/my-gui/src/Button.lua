local colors = require "colors"
local love = require "love"

local g = love.graphics
local padding = 10

local mt = {
  __index = {
    draw = function(self, dx, dy)
      local cornerRadius = padding
      g.setColor(self.buttonColor)
      local x = dx + self.x
      local y = dy + self.y
      self.actualX = x
      self.actualY = y
      g.rectangle(
        "fill", x, y, self.width, self.height,
        cornerRadius, cornerRadius
      )
      g.setColor(self.labelColor)
      g.setFont(self.font)
      g.print(self.label, x + padding, y + padding)
    end,
    handleClick = function(self, clickX, clickY)
      local x = self.actualX
      local y = self.actualY
      local clicked = clickX >= x and
          clickX <= x + self.width and
          clickY >= y and
          clickY <= y + self.height
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
  local labelWidth = font:getWidth(label)
  local labelHeight = font:getHeight()

  local instance = options
  instance.kind = "Button"
  instance.font = font
  instance.label = label
  instance.width = labelWidth + padding * 2
  instance.height = labelHeight + padding * 2
  instance.labelColor = instance.labelColor or colors.black
  instance.buttonColor = instance.buttonColor or colors.white

  setmetatable(instance, mt)

  return instance
end

return Button
