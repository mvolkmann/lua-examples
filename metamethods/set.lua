local Set = {}

function Set.intersection(a, b)
  local res = Set.new {}
  for k in pairs(a) do
    res[k] = b[k]
  end
  return res
end

function Set.tostring(set)
  local l = {}
  for e in pairs(set) do
    l[#l + 1] = tostring(e)
  end
  return "{" .. table.concat(l, ", ") .. "}"
end

function Set.union(a, b)
  local res = Set.new {}
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = true end
  return res
end

-- The functions assigned here must already be defined.
local mt = {
  __add = Set.union,
  __mul = Set.intersection,
  __tostring = Set.tostring,
  -- The methods defined here can be called with the colon operator.
  __index = {
    intersection = Set.intersection,
    union = Set.union
  }
}

function Set.new(l)
  local set = {}
  setmetatable(set, mt)
  for _, v in ipairs(l) do
    set[v] = true
  end
  return set
end

return Set
