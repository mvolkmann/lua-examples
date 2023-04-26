function print(...)
  local t = { ... }
  local len = #t
  for i, v in ipairs({ ... }) do
    io.write(tostring(v))
    if i < len then io.write(' ') end
  end
  io.write('\n')
end

print(1, 2, 3)
print("alpha", "beta")
