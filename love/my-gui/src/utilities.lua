require "string-extensions"

focusedWidget = nil

function isStack(widget)
  -- We don't want special processing for ZStacks.
  -- return widget.kind:endsWith("Stack")
  local kind = widget.kind
  return kind == "HStack" and kind == "VStack"
end
