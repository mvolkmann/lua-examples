local fun = require "glove/fun"
local love = require "love"

local g = love.graphics

local function layout(self)
  local align = self.align or "top"
  local children = self.children
  local spacerWidth = 0
  local spacing = self.spacing or 0
  local x = self.x or 0
  local y = self.y or 0

  -- Get height of tallest child.
  self.maxHeight = fun.max(
    children,
    function(child) return child:getHeight() or 0 end
  )

  -- Count spacers with no size.
  local spacerCount = fun.count(children, isSpacerWithoutSize)

  -- If there are any spacers with no size ...
  if spacerCount > 0 then
    -- Get the total width of the all other children.
    local childrenWidth = fun.sumFn(
      children,
      function(child)
        return isSpacerWithoutSize(child) and 0 or child:getWidth()
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

    local availableWidth = g.getWidth() - Glove.margin * 2

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
        child.y = y + (self.maxHeight - child:getHeight()) / 2
      elseif align == "bottom" then
        child.y = y + self.maxHeight - child:getHeight()
      else -- assume "top"
        child.y = y
      end

      x = child.x + child:getWidth()
    end
  end

  self.laidOut = true
end

local mt = {
  __index = {
    laidOut = false,
    draw = function(self, parentX, parentY)
      parentX = parentX or Glove.margin
      parentY = parentY or Glove.margin
      local x = parentX + self.x
      local y = parentY + self.y
      for i, child in ipairs(self.children) do
        if child.kind ~= "Spacer" then
          child:draw(x, y)
        end
      end
    end,

    getHeight = function(self)
      return self.maxHeight
    end,

    getWidth = function(self)
      -- If there is a Spacer child then use screen width.
      if self.haveSpacer then
        return g.getWidth() - Glove.margin * 2
      end

      -- Compute height based on children.
      local children = self.children
      local lastChild = children[#children]
      return lastChild.x + lastChild:getWidth() - self.x
    end
  }
}

-- The supported options are:
-- align: "top" (default), "center", or "bottom"
-- spacing: positive integer to add space between non-spacer children
local function HStack(options, ...)
  local to = type(options)
  assert(to == "table" or to == "nil", "HStack options must be a table.")

  local instance = options
  instance.kind = "HStack"
  instance.maxHeight = 0 -- computed in layout method
  local children = { ... }
  instance.children = children
  instance.haveSpacer = fun.some(children, isSpacerWithoutSize)
  instance.visible = true
  instance.x = 0
  instance.y = 0

  setmetatable(instance, mt)
  layout(instance)
  return instance
end

return HStack
