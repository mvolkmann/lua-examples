local colors = require "colors"
local love = require "love"

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
      g.setColor(self.labelColor)
      g.print(self.label, self.x + padding, self.y + padding)
    end,
    handleClick = function(self, x, y)
      local clicked = x >= self.x and
          x <= self.x + self.width and
          y >= self.y and
          y <= self.y + self.height
      if clicked then self.onclick() end
      return clicked
    end
  }
}

function Button(options)
  local t = type(options)
  assert(t == "table", "Button options must be a table.")

  if not options.label then
    error("Button requires label")
  end

  local font = options.font or g.getFont()
  local labelWidth = font:getWidth(options.label)
  local labelHeight = font:getHeight()

  local instance = options
  instance.kind = "Button"
  instance.font = font
  instance.width = labelWidth + padding * 2
  instance.height = labelHeight + padding * 2
  instance.labelColor = instance.labelColor or colors.black
  instance.buttonColor = instance.buttonColor or colors.white

  setmetatable(instance, mt)

  return instance
end

return Button
