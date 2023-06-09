local colors = require "colors"
local love = require "love"
local g = love.graphics

Shape = { name = "unknown", x = 0, y = 0, draggable = false, selected = false }
Shape.__index = Shape

Circle = { name = "circle" }
Circle.__index = Circle
setmetatable(Circle, Shape)

function Circle.new(x, y, radius, color)
  local instance = setmetatable({}, Circle)
  instance.x = x
  instance.y = y
  instance.radius = radius
  instance.color = color
  return instance
end

function Circle:draw()
  g.setColor(self.color)
  g.circle("fill", self.x, self.y, self.radius)
  if self.selected then
    g.setColor(colors.black)
    g.setLineWidth(5)
    g.circle("line", self.x, self.y, self.radius)
  end
end

function Circle:getHeight()
  return self.radius * 2
end

function Circle:getWidth()
  return self.radius * 2
end

function Circle:pointInside(x, y)
  local dSquared = (x - self.x) ^ 2 + (y - self.y) ^ 2
  return dSquared <= self.radius ^ 2
end

Rectangle = { name = "rectangle" }
Rectangle.__index = Rectangle
setmetatable(Rectangle, Shape)

function Rectangle.new(x, y, width, height, color)
  local instance = setmetatable({}, Rectangle)
  instance.x = x
  instance.y = y
  instance.width = width
  instance.height = height
  instance.color = color
  return instance
end

function Rectangle:draw()
  g.setColor(self.color)
  g.rectangle("fill", self.x, self.y, self.width, self.height)
  if self.selected then
    g.setColor(colors.black)
    g.setLineWidth(5)
    g.rectangle("line", self.x, self.y, self.width, self.height)
  end
end

function Rectangle:getHeight()
  return self.height
end

function Rectangle:getWidth()
  return self.width
end

function Rectangle:pointInside(x, y)
  return self.x <= x and x <= self.x + self.width and
      self.y <= y and y <= self.y + self.height
end
