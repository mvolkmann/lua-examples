function sum(...)
  local result = 0
  for _, v in ipairs({ ... }) do
    local n = tonumber(v)
    if n then result = result + n end
  end
  return result
end

print(sum())                   -- 0
print(sum(1))                  -- 1
print(sum(1, 2))               -- 3
print(sum(1, 2, 3))            -- 6
print(sum(1, true, 2, "test")) -- 3
print(sum(1, true, 2, "3"))    -- 6
