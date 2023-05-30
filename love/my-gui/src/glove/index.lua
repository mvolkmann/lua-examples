local colors = require "glove/colors"
require "glove/pprint"
require "glove/string-extensions"

local focusedWidget = nil
_glove_hoverColor = colors.green
_glove_margin = 20

function _glove_isFocused(widget)
  return widget == focusedWidget
end

function _glove_setFocus(widget)
  if focusedWidget and focusedWidget.removeFocus then
    focusedWidget:removeFocus()
  end
  focusedWidget = widget
end

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
  "Text",
  "Toggle",
  "VStack",
  "ZStack"
}

local M = {}
for _, module in ipairs(top) do
  M[module] = require("glove/" .. module)
end
for _, module in ipairs(widgets) do
  M[module] = require("glove/widgets/" .. module)
end
return M
