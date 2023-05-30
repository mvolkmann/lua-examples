local colors = require "glove/colors"
local love = require "love"

love.keyboard.setKeyRepeat(true)
local g = love.graphics
local lk = love.keyboard
local padding = 4

local inputCursor, inputProperty, inputTable

local mt = {
  __index = {
    color = colors.white,

    draw = function(self, parentX, parentY)
      if self.x and self.y then
        local x = parentX + self.x
        local y = parentY + self.y
        self.actualX = x
        self.actualY = y

        local over = self:isOver(love.mouse.getPosition())
        g.setColor(over and _glove_hoverColor or self.color)
        g.rectangle("line", x, y, self:getWidth(), self:getHeight())

        -- Get current value.
        local t = self.table
        local p = self.property
        local v = t[p] or ""

        -- Find substring of value that fits in width.
        local font = self.font
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

        g.setColor(self.color)
        g.setFont(font)
        g.print(substr, x, y)

        if _glove_isFocused(self) then
          local c = inputCursor
          if c then
            -- Draw vertical cursor line.
            local height = font:getHeight()
            local cursorPosition = math.min(c - i + 1, #substr)
            local cursorX = x + font:getWidth(substr:sub(1, cursorPosition))
            g.line(cursorX, y, cursorX, y + height)
          end
        end
      end
    end,

    getHeight = function(self)
      return self.font:getHeight() + padding * 2
    end,

    getWidth = function(self)
      return self.width
    end,

    handleClick = function(self, clickX, clickY)
      local clicked = self:isOver(clickX, clickY)
      if clicked then
        _glove_setFocus(self)

        -- Enable keyboard.
        -- TODO: Is this needed? Maybe only on mobile devices.
        love.keyboard.setTextInput(
          true,
          self.actualX, self.actualY,
          self:getWidth(), self:getHeight()
        )

        local t = self.table
        local p = self.property
        local v = t[p] or ""
        inputTable = t
        inputProperty = p
        inputCursor = #v
      end
      return clicked
    end,

    isOver = function(self, mouseX, mouseY)
      local x = self.actualX
      local y = self.actualY
      local width = self:getWidth()
      local height = self:getHeight()
      return x <= mouseX and mouseX <= x + width and
          y <= mouseY and mouseY <= y + height
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

  setmetatable(instance, mt)

  return instance
end

function inputProcessKey(key)
  -- These global variables are set in Input.lua.
  local t = inputTable
  local p = inputProperty
  local c = inputCursor
  if not t or not p then return end

  local value = t[p]

  if key == "backspace" then
    if c > 0 then
      t[p] = value:sub(1, c - 1) .. value:sub(c + 1, #value)
      inputCursor = c - 1
    end
  elseif key == "left" then
    if c > 0 then inputCursor = c - 1 end
  elseif key == "right" then
    if c < #value then inputCursor = c + 1 end
  else
    if key == "space" then key = " " end

    -- Only process printable ASCII characters.
    if #key == 1 then
      local head = c == 0 and "" or value:sub(1, c)
      local tail = value:sub(c + 1, #value)
      local shift = lk.isDown("lshift") or lk.isDown("rshift")
      local char = shift and key:upper() or key
      t[p] = head .. char .. tail
      inputCursor = c + 1
    end
  end
end

return Input
