local colors = require "colors"
local love = require "love"

local g = love.graphics

local padding = 2
local size = 24
local halfSize = size / 2
local width = size * 1.8

local mt = {
  __index = {
    draw = function(self, parentX, parentY)
      local x = parentX + self.x
      local y = parentY + self.y
      self.actualX = x
      self.actualY = y

      g.setColor(self.color)
      g.setFont(self.font)
      g.rectangle("line", x, y, width, size, halfSize, halfSize)

      local checked = self.table[self.property]
      local circleRadius = size / 2 - padding
      local circleX = checked and x + width - padding - circleRadius or x + padding + circleRadius
      local circleY = y + padding + circleRadius
      g.circle("fill", circleX, circleY, circleRadius)
    end,
    handleClick = function(self, clickX, clickY)
      local x = self.actualX
      local y = self.actualY
      local clicked = clickX >= x and
          clickX <= x + width and
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
-- color: defaults to white
-- onChange: function called when button is clicked
function Toggle(table, property, options)
  options = options or {}
  local t = type(options)
  assert(t == "table", "Checkbox options must be a table.")

  local font = options.font or g.getFont()

  local instance = options
  instance.kind = "Toggle"
  instance.color = instance.color or colors.white
  instance.font = font

  instance.table = table
  instance.property = property

  instance.width = width
  instance.height = size

  setmetatable(instance, mt)

  return instance
end

return Toggle
