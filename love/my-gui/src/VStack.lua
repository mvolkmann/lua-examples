local fun = require "fun"
local love = require "love"
local g = love.graphics
local pprint = require "pprint"

local function isSpacerWithoutSize(child)
  return child.kind == "Spacer" and not child.size
end

local function layout(self)
  print("VStack layout entered")
  local align = self.align or "start"
  local children = self.children
  local spacerWidth = 0
  local spacing = self.spacing or 0
  local x = self.x or 0
  local y = self.y or 0

  -- Get width of widest child.
  local maxWidth = fun.max(
    children,
    function(child) return child.width or 0 end
  )

  -- Count spacers with no size.
  local spacerCount = fun.count(children, isSpacerWithoutSize)

  -- If there are any spacers with no size ...
  if spacerCount > 0 then
    -- Get the total height of the all other children.
    local childrenHeight = fun.sumFn(
      children,
      function(child)
        return isSpacerWithoutSize(child) and 0 or child.height
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
    childrenHeight = childrenHeight + spacing * gapCount

    local availableHeight = g.getHeight()

    -- Compute the size of each zero width Spacer.
    spacerWidth = (availableHeight - childrenHeight) / spacerCount
  end

  -- Set the x and y properties of each non-spacer child.
  for i, child in ipairs(children) do
    if child.kind == "Spacer" then
      y = y + (child.size or spacerWidth)
    else
      child.y = y

      local prevChild = children[i - 1]
      if prevChild and prevChild.kind ~= "Spacer" then
        child.y = child.y + spacing
      end

      if align == "center" then
        child.x = x + (maxWidth - child.width) / 2
      elseif align == "end" then
        child.x = x + maxWidth - child.width
      else -- assume "start"
        child.x = x
      end

      y = child.y + child.height
    end
  end

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
-- align: "start", "center", or "end"
-- spacing: positive integer to add space between non-spacer children
function VStack(options, ...)
  local t = type(options)
  assert(t == "table" or t == "nil", "VStack options must be a table.")

  local instance = options
  instance.kind = "VStack"
  instance.children = { ... }
  setmetatable(instance, mt)
  layout(instance)
  return instance
end

return VStack
