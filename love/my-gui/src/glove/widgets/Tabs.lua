local colors = require "glove/colors"
local love = require "love"

local g = love.graphics

local tabPadding = 5

local function getTabHeight(font)
  return font:getHeight() + tabPadding * 2
end

local mt = {
  __index = {
    draw = function(self, parentX, parentY)
      parentX = parentX or Glove.margin
      parentY = parentY or Glove.margin
      local x = parentX + self.x
      local y = parentY + self.y
      self.actualX = x
      self.actualY = y

      -- local over = self:isOver(love.mouse.getPosition())
      -- g.setColor(over and Glove.hoverColor or self.color)

      local font = self.font
      g.setFont(font)
      local tabHeight = getTabHeight(font)

      for index, tab in ipairs(self.tabs) do
        local selected = index == self.selectedTabIndex
        local mode = selected and "fill" or "line"
        if selected then g.setColor(colors.gray) end

        local label = tab.label
        local tabWidth = font:getWidth(label) + tabPadding * 2
        g.setColor(self.color)
        g.rectangle(mode, x, y, tabWidth, tabHeight)
        if selected then g.setColor(colors.black) end
        g.print(label, x + tabPadding, y + tabPadding)
        x = x + tabWidth
      end

      local selectedTab = self.tabs[self.selectedTabIndex]
      local widget = selectedTab.widget
      widget:draw(parentX, parentY + tabHeight + tabPadding)
    end,

    getHeight = function(self)
      return self.font:getHeight()
    end,

    getWidth = function()
      return g.getWidth - Glove.margin * 2
    end,

    handleClick = function(self, clickX, clickY)
      local clicked = self:isOver(clickX, clickY)
      if clicked and self.onChange then
        local index = self.selectedTabIndex
        self.onChange(index, self.tabs[index])
      end
      return clicked
    end,

    isOver = function(self, mouseX, mouseY)
      local x = self.actualX
      local y = self.actualY
      if not x or not y then return false end

      local font = self.font
      local tabHeight = getTabHeight(font)

      for index, tab in ipairs(self.tabs) do
        local tabWidth = font:getWidth(tab.label) + tabPadding * 2
        local endX = x + tabWidth
        local over = mouseX >= x and mouseX <= endX and
            mouseY >= y and mouseY <= y + tabHeight
        if over then
          self.selectedTabIndex = index
          return true
        end
        x = endX
      end

      return false
    end
  }
}

-- "tabs" is an array-like table containing
--  tables with "label" and "widget" properties.
-- Supported options are:
-- font: font used for button label
-- color: color of label and checkbox; defaults to white
-- onChange: function called when button is clicked
--           (passed the tab index and tab object)
local function Tabs(tabs, options)
  options = options or {}
  assert(type(options) == "table", "Tabs options must be a table.")

  for _, tab in ipairs(tabs) do
    tab.widget.x = 0
    tab.widget.y = 0
  end

  local instance = options
  instance.kind = "Tabs"
  instance.color = instance.color or colors.white
  instance.font = options.font or g.getFont()
  instance.selectedTabIndex = 1
  instance.tabs = tabs
  instance.x = 0
  instance.y = 0

  setmetatable(instance, mt)

  table.insert(Glove.clickables, instance)

  return instance
end

return Tabs
