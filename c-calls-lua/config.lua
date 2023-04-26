print("Hello from Lua!")

_G.myBoolean = true
_G.myDouble = 1.23
_G.myInteger = 19
_G.myString = "test"

function demo()
  print("Lua function demo was called.")
end

function add(n1, n2)
  return n1 + n2
end
