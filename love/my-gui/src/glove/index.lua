local colors = require "glove/colors"
require "glove/pprint"
require "glove/string-extensions"

local focusedWidget = nil
_glove_hoverColor = colors.green
_glove_margin = 20

local top = { "colors", "fonts", "fun" }

local widgets = {
  "Button",
  "Checkbox",
  "FPS",
  "HStack",
  "Image",
  "Input",
  "RadioButtons",
  "Select",
  "Spacer",
  "Tabs",
  "Text",
  "Toggle",
  "VStack",
  "ZStack"
}

Glove = {
  hoverColor = colors.green,
  margin = 20
}

function Glove.isFocused(widget)
  return widget == focusedWidget
end

function Glove.setFocus(widget)
  if focusedWidget and focusedWidget.removeFocus then
    focusedWidget:removeFocus()
  end
  focusedWidget = widget
end

for _, module in ipairs(top) do
  Glove[module] = require("glove/" .. module)
end

for _, module in ipairs(widgets) do
  Glove[module] = require("glove/widgets/" .. module)
end

return Glove
