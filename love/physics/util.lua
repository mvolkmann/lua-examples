local M = {}

function debugString(value)
  if type(value) == 'table' then
    local s = '{ '
    for k, v in pairs(value) do
      s = s .. k .. ' = ' .. debugString(v) .. ', '
    end
    return s:sub(1, #s - 2) .. ' } '
  else
    return tostring(value)
  end
end

function dump(label, value)
  print(label .. ": " .. debugString(value))
end

return {
  dump = dump
}
