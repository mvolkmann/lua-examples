function Spacer(size)
  local t = type(size)
  assert(t == "number" or t == "nil", "Spacer size must be a number or nil.")
  return { kind = "Spacer", size = size }
end

return Spacer
