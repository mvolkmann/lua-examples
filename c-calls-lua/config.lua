print("Hello from Lua!")

_G.myBoolean = true
_G.myDouble = 1.23
_G.myInteger = 19
_G.myString = "test"
_G.myTable = {
  19,
  apple = "red",
  banana = "yellow"
}

function demo()
  print("config.lua: demo called")

  io.write("This was written to stdout by config.lua.\n")

  -- This is used to test whether the `io` standard library was loaded.
  io.output("demo.txt")
  io.write("This was written to demo.txt by config.lua.")
  io.close() -- closes the current default output file

  -- This is used to test whether the `io` standard library was loaded.
  io.input("demo.txt")
  local data = io.read()
  print("data =", data)
  io.input():close() -- gets current default input file and closes it
end

function add(n1, n2)
  --[[ This is for testing lua_pcall error handling.
  if n1 == 0 then
    error("cannot add to zero")
  end
  ]]
  return n1 + n2
end

function callC(s)
  -- l_strlen is a C function defined in main.c.
  local s, len = l_strlen(s)
  return len
end
