local fun = require "fun"
local love = require "love"
local g = love.graphics

local function isSpacerWithoutSize(child)
  return child.kind == "Spacer" and not child.size
end

local function layout(self)
  print("HStack layout entered")
  local align = self.align or "start"
  local children = self.children
  local spacerWidth = 0
  local spacing = self.spacing or 0
  local x = self.x or 0
  local y = self.y or 0

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
        if child.kind == "Spacer" then return false end
        local prevChild = children[i - 1]
        return prevChild and prevChild.kind ~= "Spacer"
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
    if child.kind == "Spacer" then
      x = x + (child.size or spacerWidth)
    else
      child.x = x

      local prevChild = children[i - 1]
      if prevChild and prevChild.kind ~= "Spacer" then
        child.x = child.x + spacing
      end

      if align == "center" then
        child.y = y + (maxHeight - child.height) / 2
      elseif align == "bottom" then
        child.y = y + maxHeight - child.height
      else -- assume "top"
        child.y = y
      end

      x = child.x + child.width
    end
  end

  self.width = avaiableWidth
  self.height = maxHeight

  self.laidOut = true
end

local mt = {
  __index = {
    laidOut = false,
    draw = function(self)
      for i, child in ipairs(self.children) do
        if child.kind ~= "Spacer" then
          child:draw(self.x, self.y)
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
  instance.kind = "HStack"
  instance.children = { ... }
  setmetatable(instance, mt)
  layout(instance)
  return instance
end

return HStack
