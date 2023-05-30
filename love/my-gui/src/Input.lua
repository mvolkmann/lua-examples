local colors = require "colors"
local love = require "love"

love.keyboard.setKeyRepeat(true)
local g = love.graphics
local padding = 4

local mt = {
  __index = {
    color = colors.white,

    draw = function(self, parentX, parentY)
      g.setColor(self.color)
      if self.x and self.y then
        local x = parentX + self.x
        local y = parentY + self.y
        self.actualX = x
        self.actualY = y

        g.rectangle("line", x, y, self.width, self.height)

        local font = self.font
        g.setFont(font)

        -- Get current value.
        local t = self.table
        local p = self.property
        local v = t[p] or ""

        -- Find substring of value that fits in width.
        local limit = self.width - padding * 2
        local i = 1
        local substr
        local substrWidth
        while true do
          substr = v:sub(i, #v)
          substrWidth = font:getWidth(substr)
          if substrWidth <= limit then break end
          i = i + 1
        end
        local truncated = i > 1

        x = x + padding
        y = y + padding
        g.print(substr, x, y)

        local c = _G.inputCursor
        if c then
          -- Draw vertical cursor line.
          local height = font:getHeight()
          local cursorPosition = math.min(c - i + 1, #substr)
          local cursorX = x + font:getWidth(substr:sub(1, cursorPosition))
          g.line(cursorX, y, cursorX, y + height)
        end
      end
    end,

    handleClick = function(self, clickX, clickY)
      local x = self.actualX
      local y = self.actualY
      local width = self.width
      local height = self.height
      local clicked = x <= clickX and clickX <= x + width and
          y <= clickY and clickY <= y + height
      if clicked then
        -- Enable keyboard.
        -- TODO: Is this needed? Maybe only on mobile devices.
        love.keyboard.setTextInput(true, x, y, width, height)

        local t = self.table
        local p = self.property
        local v = t[p] or ""
        _G.inputTable = t
        _G.inputProperty = p
        _G.inputCursor = #v
      else
        _G.inputTable = nil
        _G.inputProperty = nil
        _G.inputCursor = nil
      end
      return clicked
    end
  }
}

-- Supported options are:
-- font: font used for button label
-- color: color of label and checkbox; defaults to white
-- onChange: function called when button is clicked
function Input(table, property, options)
  local t = type(options)
  assert(t == "table" or t == "nil", "Input options must be a table.")

  local width = options.width
  assert(type(width) == "number", "Input requires a number width option.")

  local instance = options or {}

  instance.kind = "Input"

  local font = instance.font or g.getFont()
  instance.font = font

  instance.table = table
  instance.property = property

  instance.width = width
  instance.height = font:getHeight() + padding * 2

  setmetatable(instance, mt)

  return instance
end

return Input
