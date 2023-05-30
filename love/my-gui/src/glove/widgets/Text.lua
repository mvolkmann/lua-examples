local colors = require "glove/colors"
local love = require "love"

local g = love.graphics
local padding = 0

local mt = {
  __index = {
    color = colors.white,
    draw = function(self, parentX, parentY)
      g.setColor(self.color)
      if self.x and self.y then
        g.setFont(self.font)
        parentX = parentX or 0
        parentY = parentY or 0

        local v = ""
        local compute = self.compute
        if compute then
          v = compute()
        else
          local t = self.table
          local p = self.property
          v = t and p and t[p] or self.text
        end

        g.print(v, parentX + self.x + padding, parentY + self.y + padding)

        if self.debug then
          g.setColor(colors.red)
          g.rectangle(
            "line",
            parentX + self.x, parentY + self.y,
            self:getWidth(), self:getHeight()
          )
        end
      end
    end,

    getHeight = function(self)
      return self.font:getHeight() + padding * 2
    end,

    getWidth = function(self)
      if self.width then return self.width end

      local v = ""
      if compute then
        v = compute()
      else
        local t = self.table
        local p = self.property
        v = t and p and t[p] or self.text
      end
      return self.font:getWidth(v) + padding * 2
    end
  }
}

-- Supported options are:
-- font: font used for button label
-- color: color of label and checkbox; defaults to white
-- compute: function called to compute value
-- onChange: function called when button is clicked
-- property: property name whose value should be displayed
-- table: table containing the property above
-- width: used when property and table are specified
local function Text(text, options)
  local t = type(options)
  assert(t == "table" or t == "nil", "Text options must be a table.")

  if not text then
    error("Text requires text")
  end

  local instance = options or {}
  instance.kind = "Text"
  local font = instance.font or g.getFont()
  instance.font = font
  instance.text = text
  setmetatable(instance, mt)
  return instance
end

return Text
