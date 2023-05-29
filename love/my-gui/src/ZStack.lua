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

  local centerX = maxWidth / 2
  local centerY = maxHeight / 2

  -- Set the x and y properties of each non-spacer child.
  for i, child in ipairs(children) do
    local width = child.width
    local height = child.height

    if align == "center" then
      child.x = x + centerX - width / 2
      child.y = y + centerY - height / 2
    elseif align == "north" then
      child.x = x + centerX - width / 2
      child.y = y
    elseif align == "south" then
      child.x = x + centerX - width / 2
      child.y = y + maxHeight - height
    elseif align == "east" then
      child.x = x + maxWidth - width
      child.y = y + centerY - height / 2
    elseif align == "west" then
      child.x = x
      child.y = y + centerY - height / 2
    elseif align == "northeast" then
      child.x = x + maxWidth - width
      child.y = y
    elseif align == "southeast" then
      child.x = x + maxWidth - width
      child.y = y + maxHeight - height
    elseif align == "southwest" then
      child.x = x
      child.y = y + maxHeight - height
    else -- assume northwest
      child.x = x
      child.y = y
    end
  end

  self.width = maxWidth
  self.height = maxHeight
  self.laidOut = true
end

local mt = {
  __index = {
    laidOut = false,
    draw = function(self, dx, dy)
      for _, child in ipairs(self.children) do
        child:draw(dx + self.x, dy + self.y)
      end
    end
  }
}

-- The supported options are:
-- align: "center" or one of the compass directions "northwest", "north",
--        "northeast", "east", "southeast", "south", "southwest", or "west"
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
