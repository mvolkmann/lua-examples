local function map(fn, t)
  local result = {}
  for i, v in ipairs(t) do
    result[i] = fn(v)
  end
  return result
end

local numbers = { 1, 2, 3, 4, 5 }
local function square(n) return n * n end
local squares = map(square, numbers)
print(table.concat(squares, ", ")) -- 1, 4, 9, 16, 25

local function filter(fn, t)
  local result = {}
  for _, v in ipairs(t) do
    if fn(v) then
      table.insert(result, v)
    end
  end
  return result
end

local function isEven(n) return n % 2 == 0 end
local evens = filter(isEven, numbers)
print(table.concat(evens, ", ")) -- 2, 4

local function reduce(fn, t, initial)
  local acc = initial
  for _, v in ipairs(t) do
    acc = fn(acc, v)
  end
  return acc
end

local function sum(n1, n2) return n1 + n2 end
print(reduce(sum, numbers, 0)) -- 15

local function some(fn, t)
  for _, v in ipairs(t) do
    if fn(v) then return true end
  end
  return false
end

local function every(fn, t)
  for i, v in ipairs(t) do
    if not fn(v) then return false end
  end
  return true
end

print(some(function(n) return n > 3 end, numbers))  -- true
print(every(function(n) return n < 7 end, numbers)) -- true
