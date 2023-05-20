Animal = {}
Animal.__index = Animal

function Animal:displayName()
  print("Animal: name = " .. self.name)
end

Dog = {}
Dog.__index = Dog
setmetatable(Dog, Animal)

--[[ function Dog:displayName()
  print("Dog: name = " .. self.name)
end ]]
Whippet = {}
Whippet.__index = Whippet
setmetatable(Whippet, Dog)

function Whippet.new(name)
  local o = setmetatable({}, Whippet)
  o.name = name
  return o
end

--[[ function Whippet:displayName()
  print("Whippet: name = " .. self.name)
end ]]
local w = Whippet.new("Comet")
w:displayName() -- uses closest version found
