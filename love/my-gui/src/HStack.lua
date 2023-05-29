local fun = require "fun"
local g = love.graphics

local function isSpacerWithoutSize(widget)
  return widget.kind == "spacer" and not widget.size
end

local function layout(self)
  print("HStack layout entered")
  local align = self.align or "center"
  local children = self.children
  local spacerWidth = 0
  local spacing = self.spacing or 0
  local x = self.x or 0
  local y = self.y or 100

  -- Get height of tallest child.
  local maxHeight = fun.max(
    children,
    function(child) return child.height or 0 end
  )

  -- Count spacers with no size.
  local spacerCount = fun.count(children, isSpacerWithoutSize)

  -- If there are any spacers with no size ...
  if spacerCount > 0 then
    -- Get the total width of the all other children.
    local childrenWidth = fun.sumFn(
      children,
      function(child)
        return isSpacerWithoutSize(child) and 0 or child.width
      end
    )

    -- Get the number of children that are not spacers
    -- and not preceded by a spacer.
    local gapCount = fun.count(
      children,
      function(child, i)
        if child.kind == "spacer" then return false end
        local prevChild = children[i - 1]
        return prevChild and prevChild.kind ~= "spacer"
      end
    )

    -- Account for requested gaps between children.
    childrenWidth = childrenWidth + spacing * gapCount

    local availableWidth = g.getWidth()

    -- Compute the size of each zero width Spacer.
    spacerWidth = (availableWidth - childrenWidth) / spacerCount
  end

  -- Set the x and y properties of each non-spacer child.
  for i, child in ipairs(children) do
    if child.kind == "spacer" then
      x = x + (child.size or spacerWidth)
    else
      child.x = x

      local prevChild = children[i - 1]
      if prevChild and prevChild.kind ~= "spacer" then
        child.x = child.x + spacing
      end

      if align == "top" then
        child.y = y
      elseif align == "bottom" then
        child.y = y + maxHeight - child.height
      else -- assume "center"
        child.y = y + (maxHeight - child.height) / 2
      end

      x = child.x + child.width
    end
  end

  self.laidOut = true
end

local mt = {
  __index = {
    laidOut = false,
    draw = function(self)
      for i, child in ipairs(self.children) do
        if child.kind ~= "spacer" then
          child:draw()
        end
      end
    end
  }
}

-- The supported options are:
-- align: "top", "center", or "bottom"
-- spacing: positive integer to add space between non-spacer children
function HStack(options, ...)
  local t = type(options)
  assert(t == "table" or t == "nil", "HStack options must be a table.")

  local instance = options
  instance.children = { ... }
  setmetatable(instance, mt)
  layout(instance)
  return instance
end

return HStack
