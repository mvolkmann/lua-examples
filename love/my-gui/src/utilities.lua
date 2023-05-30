local colors = require "colors"
require "string-extensions"

local focusedWidget = nil
hoverColor = colors.green

function isFocused(widget)
  return widget == focusedWidget
end

function setFocus(widget)
  if focusedWidget and focusedWidget.removeFocus then
    focusedWidget:removeFocus()
  end
  focusedWidget = widget
end

function isStack(widget)
  -- We don't want special processing for ZStacks.
  -- return widget.kind:endsWith("Stack")
  local kind = widget.kind
  return kind == "HStack" and kind == "VStack"
end
