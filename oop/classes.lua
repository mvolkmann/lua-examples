local oo = require "oo"

Point = oo.class {
  -- Properties
  x = 0,
  y = 0,
  -- Methods
  distanceFromOrigin = function(p)
    return math.sqrt(p.x ^ 2 + p.y ^ 2)
  end,
  -- Metamethods
  __add = function(p1, p2)
    return Point.new { x = p1.x + p2.x, y = p1.y + p2.y }
  end,
  __tostring = function(p)
    return string.format("(%.2f, %.2f)", p.x, p.y)
  end
}

local p1 = Point.new { x = 3, y = 4 }
print(p1)                      -- (3.00, 4.00)
print(p1:distanceFromOrigin()) -- 5.0

local p2 = Point.new { x = 5, y = 1 }
local p3 = p1 + p2
print(p3) -- (8.00, 5.00)

local p4 = Point.new { y = 7 }
print(p4) -- (0.00, 7.00)
