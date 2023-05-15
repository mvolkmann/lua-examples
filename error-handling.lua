function read_number(prompt)
  io.write(prompt .. ": ")
  local number = io.read("n")
  -- The previous line does not consume the newline character.
  -- Unless that is done, the next attempt to read a number will return `nil`.
  -- The following line consumes the newline character.
  local _ = io.read()
  return number
end

function process()
  local dividend = read_number("Enter a dividend")
  if not dividend then
    -- The `error` function is the Lua equivalent of
    -- a `throw` in many other programming languages.
    -- It is passed a message and an optional integer error level.
    -- The message can be any type, but is typically a string or a table.
    error({ message = "dividend is invalid", code = 1 })
  end

  local divisor = read_number("Enter a divisor")
  if not divisor then
    error({ message = "divisor is invalid", code = 2 })
  end
  if divisor == 0 then
    error({ message = "cannot divide by zero", code = 3 })
  end

  local quotient = dividend / divisor
  io.write(string.format("The quotient is %.3f\n\n", quotient))
end

while true do
  -- The `pcall` function (short for "protected call")
  -- is the only error handling mechanism in Lua.
  -- It is passed a function to execute and
  -- optionally arguments to be passed to it.
  -- It returns a boolean indicating whether
  -- the call completed without error
  -- and an error message if one did occur.
  local success, err = pcall(process)
  if not success then
    if err then
      print(string.format("%s (code %d)", err.message, err.code))
    end
    -- print(debug.traceback()) -- prints a stack trace
    print() -- extra newline
  end
end
