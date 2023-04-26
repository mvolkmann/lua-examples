local mod = {}

-- Returns a string description of the keys and values in a table.
-- Values can be nested tables.
function mod.dump(value)
  if type(value) ~= "table" then
    return tostring(value)
  end

  local s = "{ "
  for k, v in pairs(value) do
    if type(k) ~= "number" then
      k = "\"" .. k .. "\""
    end
    s = s .. k .. "=" .. mod.dump(v) .. ", " -- recursive
  end
  if #s > 2 then s = s:sub(1, -3) end        -- removes last comma and space
  return s .. " }"
end

-- Returns a string containing all the values in a table,
-- each separated by a comma and a space.
-- Values cannot be nested tables.
function mod.valuesString(obj)
  if type(obj) ~= "table" then
    return ""
  end

  s = ""
  for index, v in ipairs(obj) do
    s = s .. v .. ", "
  end
  return s:sub(1, -3)
end

return mod
