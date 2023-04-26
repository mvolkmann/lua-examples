local fun = require("fun")
local utility = require("utility")

local scores = { 7, 4, 13 }
print(utility.dump(scores))
print(utility.valuesString(scores))

local complex = { foo = 1, bar = true, baz = { 1, 2, 3 } }
print(utility.dump(complex))

-- The `map` and `filter` methods returns an iterator.
-- Calling `:totable()` on an iterator returns a table.

-- Use `map` to double the numbers in a table.
local function double(n) return n * 2 end
doubled_iter = fun.map(double, scores)
print("Doubled Scores")
fun.each(print, doubled_iter) -- 14 8 26

-- Use `filter` to get odd numbers from a table.
local function odd(n) return n % 2 == 1 end
odd_iter = fun.filter(odd, scores)
print("Odd Scores")
fun.each(print, odd_iter) -- 7 3

-- Use `reduce` to sum the numbers in a table.
local function add(a, b) return a + b end
total = fun.reduce(add, 0, scores)
print("Total is " .. total) -- 24

-- Do the same with the `sum` function.
print("Total is " .. fun.sum(scores)) -- 24

-- There are MANY more functions in the luafun library!
