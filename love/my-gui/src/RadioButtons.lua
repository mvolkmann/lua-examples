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

      local spacing = self.height
      local circleCenterY = y + halfSize
      local circleRadius = halfSize
      for _, choice in ipairs(choices) do
        local circleCenterX = x + halfSize
        g.circle("line", circleCenterY, circleCenterY, circleRadius)
        x = x + size + spacing
        g.print(choice.label, x, y)
        x = x + spacing * 2
      end
    end,
    handleClick = function(self, clickX, clickY)
      local x = self.actualX
      local y = self.actualY
      local spacing = self.height
      local circleCenterY = y + halfSize
      local circleRadiusSquared = halfSize ^ 2

      for _, choice in ipairs(self.choices) do
        local circleCenterX = x + halfSize
        local distanceSquared =
            (circleCenterX - clickX) ^ 2 +
            (circleCenterY - clickY) ^ 2
        if distanceSquared <= circleRadiusSquared then
          local value = choice.value
          local t = self.table
          local p = self.property
          t[p] = value
          self.onChange(t, p, value)
          return true -- captured click
        end
        x = x + spacing * 2
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
-- onChange: function called when button is clicked
function RadioButtons(choices, table, property, options)
  local t = type(choices)
  assert(t == "table", "Toggle choices must be a table.")

  options = options or {}
  local t = type(options)
  assert(t == "table", "RadioButtons options must be a table.")

  local font = options.font or g.getFont()

  local instance = options
  instance.kind = "Toggle"
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
