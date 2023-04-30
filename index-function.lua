local t = { apple = "red" }

--[[ local mt = {
  __index = function(_, key) -- first parameter is the table
    return "unknown"
  end
} ]]
local mt = {
  __index = { banana = "yellow" }
}

setmetatable(t, mt)
print(t.apple)  -- red
print(t.banana) -- unknown
