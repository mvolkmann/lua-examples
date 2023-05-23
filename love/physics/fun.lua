local M = {}

function M.all(t, predicate)
  for _, v in ipairs(t) do
    if not predicate(v) then return false end
  end
  return true
end

function M.reduce(fn, t, initial)
  local acc = initial or 0
  for _, v in ipairs(t) do
    acc = fn(acc, v)
  end
  return acc
end

function M.sum(n1, n2) return n1 + n2 end

function M.tableSum(t)
  return M.reduce(M.sum, t)
end

function M.xor(n1, n2) return bit.bxor(n1, n2) end

return M
