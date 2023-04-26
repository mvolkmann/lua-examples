-- Define Animal class with properties `name` and `says`.
Animal = {name = "", says = ""}

-- Animal constructor
function Animal.new(kind, name, says)
  setmetatable({}, self)

  -- Set properties.
  self.kind = kind
  self.name = name
  self.says = says

  return self
end

-- Animal method
function Animal:toString()
  local text = "%s is a %s and says %s."
  return string.format(text, self.name, self.kind, self.says)
end

-- Create an Animal instance.
dog = Animal.new("dog", "Comet", "bark")

print(dog.says) -- access property; bark
print(dog:toString()) -- call method; Comet is a dog and says bark.

-- Define Giraffe class inheriting from the Animal class.
Giraffe = Animal.new()

-- Giraffe constuctor
function Giraffe.new(name, height)
  setmetatable({}, self)

  -- Set superclass properties.
  self.kind = "giraffe"
  self.name = name
  self.says = "nothing"

  -- Set properties unique to this class.
  self.height = height

  return self
end

-- Giraffe method
function Giraffe:report()
  local text = "%s %s is %d feet tall."
  return string.format(text, self.name, self.kind, self.height)
end

-- Create Giraffe instance.
g = Giraffe:new("Geoffrey", 18) -- creates an instance

print(g.height) -- access property; 18
print(g:toString()) -- call method; Geoffrey is a giraffe and says nothing.
print(g:report()) -- call method; Geoffrey giraffe is 18 feet tall.
