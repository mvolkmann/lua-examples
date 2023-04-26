my_table = {alpha = 7}
print(getmetatable(my_table)) -- nil; no metatable assigned yet

-- Create a metatable containing one metamethod named `__index`.
-- Its value is a table holding default key/value pairs.
-- my_metatable = {__index = {alpha = 1, beta = 2}}
-- setmetatable(my_table, my_metatable)

-- setmetatable(my_table, {__index = {alpha = 1, beta = 2}})

-- my_table.__index = {alpha = 1, beta = 2}
-- setmetatable(my_table, my_table)

print(my_table.alpha, my_table.beta, my_table.gamma) -- 7 2 nil
