io.input("haiku.txt")

--[[ local all = io.read("a")
print(all) ]]
--[[ while true do
  local line = io.read("n")
  if not line then break end
  print(line)
end ]]
io.input("numbers.txt")
while true do
  local n = io.read("n")
  if not n then break end
  print(n)
end
