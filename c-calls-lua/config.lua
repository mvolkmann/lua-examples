print("Hello from Lua!")

_G.myBoolean = true
_G.myDouble = 1.23
_G.myInteger = 19
_G.myString = "test"

function demo()
  print("config.lua: demo called")
end

function add(n1, n2)
  return n1 + n2
end

function callC(s)
  -- l_strlen is a C function defined in main.c.
  local s, len = l_strlen(s)
  return len
end
