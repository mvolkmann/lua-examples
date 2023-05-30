function isSpacerWithoutSize(child)
  return child.kind == "Spacer" and not child.size
end

local mt = {
  __index = {
    getHeight = function(self) return 0 end,
    getWidth = function(self) return 0 end
  }
}

local function Spacer(size)
  local t = type(size)
  assert(t == "number" or t == "nil", "Spacer size must be a number or nil.")
  local instance = { kind = "Spacer", size = size }
  setmetatable(instance, mt)
  return instance
end

return Spacer
