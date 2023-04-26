--[[
local my_module = {} -- a table

my_module.some_variable = "some value"

function my_module.some_function(p1, p2)
  print("some_function was passed " .. p1 .. " and " .. p2)
end

return my_module
]]
return {
  some_variable = "some value",
  some_function = function(p1, p2)
    print("some_function was passed " .. p1 .. " and " .. p2)
  end
}
