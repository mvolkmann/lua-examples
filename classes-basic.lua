-- Define a Shape class.
Shape = { name = "unknown", sides = 0 }
Shape.__index = Shape

-- Constructor
-- To make this an abstract class, remove this function.
--[[
function Shape.new(sides)
  -- local instance = setmetatable({}, metatable)
  local instance = setmetatable({}, Shape)
  instance.sides = sides
  return instance
end
]]
-- Method
function Shape:report()
  print(string.format("%s has %d sides and area %f.", self.name, self.sides,
    self:area()))
end

--[[
triangle = Shape.new(3)
rectangle = Shape.new(4)
triangle:report() -- Shape has 3 sides.
rectangle:report() -- Shape has 4 sides.
]]
-- Define a Triangle class.
Triangle = { name = "triangle", sides = 3 }
Triangle.__index = Triangle
setmetatable(Triangle, Shape)

-- Constructor
function Triangle.new(base, height)
  local instance = setmetatable({}, Triangle)
  instance.base = base
  instance.height = height
  return instance
end

-- Method
function Triangle:area()
  return self.base * self.height / 2
end

local triangle = Triangle.new(4, 6)
triangle:report()                   -- Shape has 3 sides.
print("area = " .. triangle:area()) -- 12.0

-- Define a Rectangle class.
Rectangle = { name = "rectangle", sides = 4 }
Rectangle.__index = Rectangle
setmetatable(Rectangle, Shape)

-- Constructor
function Rectangle.new(width, height)
  local instance = setmetatable({}, Rectangle)
  instance.width = width
  instance.height = height
  return instance
end

-- Method
function Rectangle:area()
  return self.width * self.height
end

local rectangle = Rectangle.new(4, 6)
rectangle:report()                   -- Shape has 4 sides.
print("area = " .. rectangle:area()) -- 24

-- Define a Square class.
Square = { name = "square" }
Square.__index = Square
setmetatable(Square, Rectangle)

-- Constructor
function Square.new(side)
  local instance = setmetatable({}, Square)
  instance.side = side
  return instance
end

-- Method
function Square:area()
  return self.side ^ 2
end

local square = Square.new(5)
square:report()                   -- Shape has 4 sides.
print("area = " .. square:area()) -- 25.0
