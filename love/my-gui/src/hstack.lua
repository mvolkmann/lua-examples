local M = {}

local fun = require "fun"
local g = love.graphics

local padding = 0

local function isSpacerWithoutSize(widget)
  return widget.kind == "spacer" and not widget.size
end

local function compute(self)
  print("HStack compute entered")
  local align = self.align or "center"
  local children = self.children
  local spacerWidth = 0
  local spacing = self.spacing or 0
  local x = self.x or 0
  local y = self.y or 100

  -- Get height of tallest child.
  local maxHeight = fun.reduce(
    children,
    function(acc, w)
      local h = w.height or 0
      return h > acc and h or acc
    end
  )

  -- Count spacers with no size.
  local spacerCount = fun.reduce(
    children,
    function(acc, w)
      return isSpacerWithoutSize(w) and acc + 1 or acc
    end
  )

  -- If there are any spacers with no size ...
  if spacerCount > 0 then
    -- Get the total width of the all other children.
    local childrenWidth = fun.reduce(
      children,
      function(acc, w)
        return isSpacerWithoutSize(w) and acc or acc + w.width
      end
    )

    -- Get the number of children that are not spacers
    -- and not preceded by a spacer.
    local gapCount = fun.reduce(
      children,
      function(acc, w, i)
        if w.kind == "spacer" then return acc end
        local prevW = children[i - 1]
        if not prevW or prevW.kind == "spacer" then
          return acc
        else
          return acc + 1
        end
      end
    )

    -- Account for requested gaps between children.
    childrenWidth = childrenWidth + spacing * gapCount

    local availableWidth = g.getWidth()

    -- Compute the size of each zero width Spacer.
    spacerWidth = (availableWidth - childrenWidth) / spacerCount
  end

  for i, w in ipairs(children) do
    if w.kind == "spacer" then
      x = x + (w.size or spacerWidth)
    else
      w.x = x

      local prevW = children[i - 1]
      if prevW and prevW.kind ~= "spacer" then
        w.x = w.x + spacing
      end

      if align == "top" then
        w.y = y
      elseif align == "bottom" then
        w.y = y + maxHeight - w.height
      else -- assume "center"
        w.y = y + (maxHeight - w.height) / 2
      end

      x = w.x + w.width
    end
  end

  self.computed = true
end

local mt = {
  __index = {
    computed = false,
    draw = function(self)
      -- Can set this to false to trigger recomputing.
      if not self.computed then compute(self) end

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
function M.new(options, ...)
  local t = type(options)
  assert(t == "table" or t == "nil", "HStack options must be a table.")

  local instance = options
  instance.children = { ... }

  setmetatable(instance, mt)

  compute(instance)

  return instance
end

return M
