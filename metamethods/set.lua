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

-- Determines if a is a subset of b.
-- This means all elements of a are in b.
-- It is possible that b contains exactly the same elements as a.
function Set.subset(a, b)
  for k in pairs(a) do
    if not b[k] then return false end
  end
  return true
end

-- Determines if a is a proper subset of b.
-- This means all elements of a are in b,
-- but b has at least one element that is not in a.
function Set.proper_subset(a, b)
  return a <= b and not (b <= a)
end

function Set.equal(a, b)
  return a <= b and b <= a
end

function Set.union(a, b)
  local res = Set.new {}
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = true end
  return res
end

-- The functions assigned here must already be defined.
local mt = {
  __metatable = "private",
  __add = Set.union,
  __eq = Set.equal,
  __le = Set.subset,
  __lt = Set.proper_subset,
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
