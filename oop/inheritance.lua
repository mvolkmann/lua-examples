local oo = require "oo"

Shape = oo.class {
  abstract = true,
  report = function(self)
    print(string.format("%s has %d sides and area %0.1f", self.name, self.sides,
      self:area()))
  end
}

Triangle = oo.subclass(Shape, {
  name = "triangle",
  sides = 3,
  area = function(self) return 0.5 * self.base * self.height end
})
local triangle = Triangle.new { base = 4, height = 6 }
print(triangle:area()) -- 12.0
triangle:report()                         -- triangle has 3 sides and area 12.000000

Rectangle = oo.subclass(Shape, {
  name = "rectangle",
  sides = 4,
  area = function(self) return self.width * self.height end
})
local rectangle = Rectangle.new { width = 4, height = 6 }
print(rectangle:area()) -- 24
rectangle:report()                             -- rectangle has 4 sides

Square = oo.subclass(Rectangle, {
  name = "square",
  area = function(self) return self.side ^ 2 end
})
local square = Square.new { side = 5 }
print(square:area()) -- 25.0
square:report()                          -- square has 4 sides
