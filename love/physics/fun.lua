local M = {}

function M.every(t, predicate)
  for _, v in ipairs(t) do
    if not predicate(v) then return false end
  end
  return true
end

-- This returns all table items that matches.
function M.filter(t, fn)
  local result = {}
  for _, v in ipairs(t) do
    if fn(v) then
      table.insert(result, v)
    end
  end
  return result
end

-- This returns the first table item that matches.
function M.find(t, fn)
  for _, v in ipairs(t) do
    if fn(v) then return v end
  end
end

function M.map(t, fn)
  local result = {}
  for i, v in ipairs(t) do
    result[i] = fn(v)
  end
  return result
end

function M.reduce(t, fn, initial)
  local acc = initial or 0
  for _, v in ipairs(t) do
    acc = fn(acc, v)
  end
  return acc
end

function M.some(t, fn)
  for _, v in ipairs(t) do
    if fn(v) then return true end
  end
  return false
end

function M.sum(n1, n2) return n1 + n2 end

function M.tableSum(t)
  return M.reduce(t, M.sum)
end

function M.xor(n1, n2) return bit.bxor(n1, n2) end

return M
