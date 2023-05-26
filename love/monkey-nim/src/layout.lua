local love = require "love"

-- Each item must have the properties "x", "y", "width", and "height"
-- and they must have a "draw" method that uses those.
-- For an example, see Button.lua.
-- This has not been tested yet!
function layout(items, x, y, marginX, marginY)
  marginX = marginX or 0
  marginY = marginY or 0

  for index, item in ipairs(items) do
    item.x = x
    item.y = y
    item:draw()
    if marginX > 0 then x = x + item.width + marginX end
    if marginY > 0 then y = y + item.height + marginY end
  end
end
