local Point = {}

local mt = {
  __index = {
    distance1 = function(point)
      return math.sqrt(point.x ^ 2 + point.y ^ 2)
    end
  }
}

function Point.distance2(point)
  return math.sqrt(point.x ^ 2 + point.y ^ 2)
end

function Point.new(p)
  p = p or { x = 0, y = 0 }

  function p:distance3()
    return math.sqrt(self.x ^ 2 + self.y ^ 2)
  end

  setmetatable(p, mt)
  return p
end

local pt = Point.new({ x = 3, y = 4 })

-- Call function defined on Point instance as a method.
-- This is bad because a new function is attached to every instance.
print(pt:distance3()) -- 5.0

-- Call function defined in Point table as a function.
-- This is the approach used by the `table` type for functions like `concat`,
-- but it is not as concise as the last approach below.
print(Point.distance2(pt)) -- 5.0

-- Call function defined in metatable __index as a function.
-- This is not a nice as the previous call because `pt` must be repeated.
print(pt.distance1(pt)) -- 5.0

-- Call function defined in metatable __index as a method.
-- This is the preferred approach because only one copy of the function
-- is defined (in the shared metatable) and calls to it are concise.
print(pt:distance1()) -- 5.0
