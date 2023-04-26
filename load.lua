local name = "World"
local code = "print('Hello, " .. name .. "!')"
local fn = load(code)
if fn then print(fn()) end

local n = 0
local last = 4
local function getCode()
  -- local code
  if n == 0 then
    code = "print("
  elseif n < last then
    code = n .. ","
  elseif n == last then
    code = n .. ")"
  elseif n > last then
    code = nil
  end

  n = n + 1
  return code
end

fn = load(getCode)
if fn then print(fn()) end
