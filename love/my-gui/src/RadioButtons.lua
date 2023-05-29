local colors = require "colors"
local love = require "love"

local g = love.graphics

local padding = 2
local size = 24
local circleRadius = size / 2
local width = size * 1.8

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
      local height = font:getHeight()
      local dy = (size - height) / 2

      local spacing = circleRadius
      local circleCenterY = y + circleRadius
      local selectedValue = self.table[self.property]

      for _, choice in ipairs(self.choices) do
        local circleCenterX = x + circleRadius
        g.circle("line", circleCenterX, circleCenterY, circleRadius)
        if choice.value == selectedValue then
          g.circle("fill", circleCenterX, circleCenterY, circleRadius - 2)
        end
        x = x + size + spacing
        g.print(choice.label, x, y + dy)
        x = x + self.font:getWidth(choice.label) + spacing * 2
      end
    end,
    handleClick = function(self, clickX, clickY)
      local x = self.actualX
      local y = self.actualY
      local font = self.font
      local spacing = circleRadius

      for _, choice in ipairs(self.choices) do
        local choiceWidth = size + spacing + font:getWidth(choice.label)
        if x <= clickX and clickX <= x + choiceWidth and
            y <= clickY and clickY <= y + size then
          local value = choice.value
          local t = self.table
          local p = self.property
          t[p] = value
          self.onChange(t, p, value)
          return true -- captured click
        end
        x = x + size + spacing
        x = x + self.font:getWidth(choice.label) + spacing * 2
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
-- onChange: function called when button is clicked
function RadioButtons(choices, table, property, options)
  local t = type(choices)
  assert(t == "table", "RadioButtons choices must be a table.")

  options = options or {}
  local t = type(options)
  assert(t == "table", "RadioButtons options must be a table.")

  local font = options.font or g.getFont()

  local instance = options
  instance.kind = "RadioButtons"
  instance.choices = choices
  instance.color = instance.color or colors.white
  instance.font = font

  instance.table = table
  instance.property = property

  local height = font:getHeight()
  local width = 0
  for _, choice in ipairs(choices) do
    -- using height for spacing
    width = width + size + height + font:getWidth(choice.label) + height * 2
  end
  width = width - height * 2

  instance.width = width
  instance.height = size

  setmetatable(instance, mt)

  return instance
end

return RadioButtons
