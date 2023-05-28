local M = {}

function M.new(size)
  local t = type(size)
  assert(t == "number" or t == "nil", "Spacer size must be a number or nil.")
  return { kind = "spacer", size = size }
end

return M
