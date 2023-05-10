local old_print = print
function print(...)
  io.write("> ")
  old_print(...)
end

print("one", "two", "three")
print()
