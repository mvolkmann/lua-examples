local colors = require "colors"
local fun = require "fun"
local love = require "love"

local g = love.graphics

local defaultValue = "Select ..."
local padding = 2

local mt = {
  __index = {
    draw = function(self, parentX, parentY)
      local x = parentX + self.x
      local y = parentY + self.y
      self.actualX = x
      self.actualY = y

      g.setColor(self.color)
      local font = self.font
      g.setFont(font)

      local selectedValue = self.table[self.property]
      local selectedChoice = fun.find(self.choices, function(choice)
        return choice.value == selectedValue
      end)

      g.rectangle("line", x, y, self.width, self.height)
      local value = selectedChoice and selectedChoice.label or "Select ..."
      g.print(value, x + padding, y + padding)

      local fontHeight = font:getHeight()
      local triangleSize = fontHeight - 8
      local triangleX = x + self.width - 6 - triangleSize
      local triangleTop = y + 6
      local triangleBottom = triangleTop + triangleSize
      g.polygon(
        "fill",
        triangleX, triangleTop,
        triangleX + triangleSize, triangleTop,
        triangleX + triangleSize / 2, triangleBottom
      )

      if self.open then
        local dy = fontHeight + padding * 2
        for _, choice in ipairs(self.choices) do
          y = y + dy
          g.setColor(colors.white)
          g.rectangle("fill", x, y, self.width, self.height)
          g.setColor(colors.black)
          g.print(choice.label, x + padding, y + padding)
        end
      end
    end,
    handleClick = function(self, clickX, clickY)
      local x = self.actualX
      local y = self.actualY
      local height = self.height
      local width = self.width

      if x <= clickX and clickX <= x + width and
          y <= clickY and clickY <= y + height then
        self.open = not self.open
        return
      end

      local fontHeight = self.font:getHeight()
      local dy = fontHeight + padding * 2
      for _, choice in ipairs(self.choices) do
        y = y + dy
        if x <= clickX and clickX <= x + width and
            y <= clickY and clickY <= y + height then
          local value = choice.value
          local t = self.table
          local p = self.property
          t[p] = value
          self.onChange(t, p, value)
          self.open = false
          self.selectedLabel = choice.label
          return true -- captured click
        end
      end

      return false -- did not capture click
    end
  }
}

-- choices is an array-like table containing
-- tables with label and value properties.
--
-- Supported options are:
-- color: defaults to white
-- font: font used for choice labels
-- onChange: function called when a choice is selected
function Select(choices, table, property, options)
  local t = type(choices)
  assert(t == "table", "Select choices must be a table.")

  options = options or {}
  local t = type(options)
  assert(t == "table", "Select options must be a table.")

  local font = options.font or g.getFont()

  local instance = options
  instance.kind = "Select"
  instance.choices = choices
  instance.color = instance.color or colors.white
  instance.font = font

  instance.table = table
  instance.property = property
  instance.open = false

  -- Find the widest choice label.
  local maxWidth = fun.max(choices, function(choice)
    return font:getWidth(choice.label)
  end)
  local defaultWidth = font:getWidth(defaultValue)
  if defaultWidth > maxWidth then maxWidth = defaultWidth end

  local fontHeight = font:getHeight()
  instance.width = maxWidth + padding * 3 + fontHeight
  instance.height = fontHeight + padding * 2

  setmetatable(instance, mt)

  return instance
end

return Select
