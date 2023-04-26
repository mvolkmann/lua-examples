local M = {}

-- This adds a function to the builtin `string` module.
function string.starts_with(source, target)
  -- 1 is the index at which to start the search.
  -- true turns off use of patterns which improves performance.
  return source:find(target, 1, true) == 1
end

local function move_metamethods(source, target)
  for k, v in pairs(source) do
    if k:starts_with("__") then
      target[k] = v
      source[k] = nil
    end
  end
end

-- This creates a table that simulates an OO class.
-- The `defaults` parameter is a table that holds default property values
-- and optional metamethods like `__tostring`.
function M.class(defaults)
  assert(type(defaults) == "table", "defaults must be a table")

  local metatable = { __index = defaults }
  move_metamethods(defaults, metatable)

  return {
    meta = metatable, -- used by subclass function
    new = function(initial)
      assert(not defaults.abstract, "cannot create instance of abstract class")
      local instance = initial or {}
      setmetatable(instance, metatable)
      return instance
    end
  }
end

-- This creates a table that simulates an OO subclass.
-- The `defaults` parameter is a table that holds default property values
-- and optional metamethods like `__tostring`.
function M.subclass(baseClass, defaults)
  assert(type(baseClass) == "table", "base class must be a table")
  assert(type(defaults) == "table", "defaults must be a table")

  local metatable = { __index = defaults }
  move_metamethods(defaults, metatable)
  setmetatable(metatable.__index, baseClass.meta)

  return {
    meta = metatable, -- used by subclass function
    new = function(initial)
      local instance = initial or {}
      setmetatable(instance, metatable)
      return instance
    end
  }
end

return M
