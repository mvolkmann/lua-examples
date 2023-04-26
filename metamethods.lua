-- Classes are defined as tables.
Point = {}

-- Setting the `__index` property of a table causes
-- lookup of missing keys to search the associated metatable.
-- In this case the metatable is associated in the `new` function below.
Point.__index = Point

-- This uses . instead of : to prevent calling it on an instance.
function Point.new(x, y)
  -- This associates a metatable with the table in Point.
  -- TODO: How does this avoid sharing the same Point table for all instances?
  local instance = setmetatable({}, Point)
  instance.x = x
  instance.y = y
  return instance
end

-- This defines a metamethod to implement
-- the `+` operator for Point instances.
-- It uses . instead of : because it IS NOT called as a method.
function Point.__add(pt1, pt2)
  local x = pt1.x + pt2.x
  local y = pt1.y + pt2.y
  return Point.new(x, y)
end

function Point.__call()
  print("I was called!")
end

function Point.__eq(pt1, pt2)
  return pt1.x == pt2.x and pt1.y == pt2.y
end

function Point.__ne(pt1, pt2)
  return pt1.x ~= pt2.x or pt1.y ~= pt2.y
end

-- This is used when a Point is printed.
-- It uses : instead of . because it IS called as a method.
function Point:__tostring()
  return string.format("(%d, %d)", self.x, self.y)
end

-- Using : instead of . here because this is a method.
function Point:distanceFromOrigin()
  return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

local pt1 = Point.new(3, 4)
print(pt1)

print(pt1:distanceFromOrigin())

local pt2 = Point.new(2, 1)
print(pt2)

local pt3 = pt1 + pt2
print(pt3)

print(pt1 == pt2) -- false
print(pt1 ~= pt2) -- true

pt1() -- calls the `__call` function
