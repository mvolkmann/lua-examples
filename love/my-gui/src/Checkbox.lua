local colors = require "colors"
local love = require "love"

local g = love.graphics

local padding = 4
local size = 24
local spacing = size * 0.4

local mt = {
  __index = {
    draw = function(self, parentX, parentY)
      local x = parentX + self.x
      local y = parentY + self.y
      self.actualX = x
      self.actualY = y

      g.setColor(self.color)
      g.rectangle("line", x, y, size, size)

      local checked = self.table[self.property]
      if checked then
        local s = size - padding * 2
        g.rectangle("fill", x + padding, y + padding, s, s)
      end

      g.setFont(self.font)
      local height = self.font:getHeight()
      local dy = (size - height) / 2
      g.print(self.label, x + size + spacing, y + dy)

      if self.debug then
        g.setColor(colors.red)
        g.rectangle("line", x, y, self.width, self.height)
      end
    end,
    handleClick = function(self, clickX, clickY)
      local x = self.actualX
      local y = self.actualY
      local clicked = clickX >= x and
          clickX <= x + size and
          clickY >= y and
          clickY <= y + size
      if clicked then
        local t = self.table
        local p = self.property
        local checked = t[p]
        t[p] = not checked
        self.onChange(t, p, not checked)
      end
      return clicked
    end
  }
}

-- Supported options are:
-- font: font used for button label
-- color: color of label and checkbox; defaults to white
-- onChange: function called when button is clicked
function Checkbox(label, table, property, options)
  options = options or {}
  local t = type(options)
  assert(t == "table", "Checkbox options must be a table.")

  local font = options.font or g.getFont()

  local instance = options
  instance.kind = "Checkbox"
  instance.color = instance.color or colors.white
  instance.font = font
  instance.label = label

  instance.table = table
  instance.property = property

  instance.width = size + spacing + font:getWidth(label)
  instance.height = math.max(size, font:getHeight())

  setmetatable(instance, mt)

  return instance
end

return Checkbox
