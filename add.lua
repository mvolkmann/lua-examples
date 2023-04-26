io.write("First Number: ")
-- This form of `io.read` returns a number or nil if a non-number is entered.
local n1 = io.read("*number")

io.write("Second Number: ")
local n2 = io.read("*number")

if n1 and n2 then
  local sum = n1 + n2
  print("Sum: " .. sum)
else
  print("An invalid number was entered.")
end
