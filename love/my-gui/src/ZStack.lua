local fun = require "fun"
local love = require "love"
local g = love.graphics

local function layout(self)
  print("ZStack layout entered")
  local align = self.align or "NW"
  local children = self.children
  local x = self.x or 0
  local y = self.y or 0

  -- Get width of widest child.
  local maxWidth = fun.max(
    children,
    function(child) return child.width or 0 end
  )

  -- Get height of tallest child.
  local maxHeight = fun.max(
    children,
    function(child) return child.height or 0 end
  )

  -- Set the x and y properties of each non-spacer child.
  for i, child in ipairs(children) do
    child.x = x
    child.y = y
  end

  self.laidOut = true
end

local mt = {
  __index = {
    laidOut = false,
    draw = function(self)
      for i, child in ipairs(self.children) do
        child:draw(self.x, self.y)
      end
    end
  }
}

-- The supported options are:
-- align: TODO ???
function ZStack(options, ...)
  local t = type(options)
  assert(t == "table" or t == "nil", "ZStack options must be a table.")

  local instance = options
  instance.kind = "ZStack"
  instance.children = { ... }
  setmetatable(instance, mt)
  layout(instance)
  return instance
end

return ZStack
