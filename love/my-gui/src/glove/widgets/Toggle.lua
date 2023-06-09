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

      local over = self:isOver(love.mouse.getPosition())
      g.setColor(over and Glove.hoverColor or self.color)
      g.setFont(self.font)
      g.rectangle("line", x, y, width, size, halfSize, halfSize)

      g.setColor(self.color)

      local checked = self.table[self.property]
      local circleRadius = size / 2 - padding
      local circleX = checked and x + width - padding - circleRadius or x + padding + circleRadius
      local circleY = y + padding + circleRadius
      g.circle("fill", circleX, circleY, circleRadius)
    end,

    getHeight = function()
      return size
    end,

    getWidth = function()
      return width
    end,

    handleClick = function(self, clickX, clickY)
      local clicked = self:isOver(clickX, clickY)
      if clicked then
        Glove.setFocus(self)
        local t = self.table
        local p = self.property
        local checked = t[p]
        t[p] = not checked
        if self.onChange then
          self.onChange(t, p, not checked)
        end
        print("toggled " .. p)
      end
      return clicked
    end,

    isOver = function(self, mouseX, mouseY)
      local x = self.actualX
      local y = self.actualY
      if not x or not y then return false end

      return x <= mouseX and mouseX <= x + width and
          y <= mouseY and mouseY <= y + size
    end
  }
}

-- t[property] is set to true or false.
-- Supported options are:
-- color: defaults to white
-- onChange: function called when button is clicked
local function Toggle(t, property, options)
  options = options or {}
  assert(type(options) == "table", "Toggle options must be a table.")

  local font = options.font or g.getFont()

  local instance = options
  instance.kind = "Toggle"
  instance.color = instance.color or Glove.colors.white
  instance.font = font
  instance.table = t
  instance.property = property
  instance.visible = true

  setmetatable(instance, mt)

  table.insert(Glove.clickables, instance)

  return instance
end

return Toggle
