local t = { alpha = 7 }
print(getmetatable(t)) -- nil

local m = { __index = { alpha = 1, beta = 2 }, greet = "Hello" }
setmetatable(t, m)
print(t.alpha, t.beta)       -- 7 2
print(getmetatable(t).greet) -- Hello

local m2 = {
  -- This function is only called when table does not contain key.
  __index = function() -- passed table and key
    -- This can determine the value to return
    -- based on key and data in table.
    return "unknown"
  end,
  greet = "Hola"
}
setmetatable(t, m2)
print(t.alpha, t.beta)       -- 7 unknown
print(getmetatable(t).greet) -- Hola

-- TODO: Add an example of using __newindex.
--[[
m3 = {
  __newindex = function(t, v)
  end
}
setmetatable(t, m3)
]]
local point = { x = 3, y = 7 }
local m4 = {
  __add = function(pt1, pt2)
    return { x = pt1.x + pt2.x, y = pt1.y + pt2.y }
  end,
  __tostring = function(pt)
    return string.format("(%0.1f, %0.1f)", pt.x, pt.y)
  end
}
setmetatable(point, m4)

print(point)        -- (3.0, 7.0)
local sum = point + { x = 2, y = 1 }
print(sum.x, sum.y) -- 5 8
setmetatable(sum, m4)
print(sum)          -- (5.0, 8.0)

-- We would like to have an easy way to associate the same metatable
-- with many tables that have the same set of keys.
-- These tables can be viewed as instances of a class.

Point = {}
-- This assigns a metatable as a property of Point
-- only to avoid adding it to the top-level namespace.
Point.metatable = {
  __add = function(pt1, pt2)
    return Point.new({ x = pt1.x + pt2.x, y = pt1.y + pt2.y })
  end,
  __tostring = function(pt)
    return string.format("(%0.1f, %0.1f)", pt.x, pt.y)
  end
}

function Point.new(pt)
  obj = pt or {}
  setmetatable(obj, Point.metatable)
  return obj
end

-- Is the `self` variable only set in functions that use a colon?

function Point.test1()
  print("in test1")
  -- print("self =" .. self)
end

function Point:test2()
  print("in test2")
  -- print("self =" .. self)
end

local p1 = Point.new({ x = 3, y = 7 })
local p2 = Point.new({ x = 2, y = 1 })
print(p1 + p2) -- (x = 5.0, 8.0)

-- p1.test1()
p1:test2() -- TODO: Why does this give an error?
