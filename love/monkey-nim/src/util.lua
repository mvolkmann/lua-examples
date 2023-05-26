local function debugString(value)
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

function dec(t, k, d) t[k] = t[k] - (d or 1) end

function inc(t, k, d) t[k] = t[k] + (d or 1) end

local futures = {}

-- This schedules a function to run in the future.
function future(fn, seconds)
  futures[fn] = os.time() + seconds
end

-- Call this near the beginning of love.update.
function processFutures()
  for fn, time in pairs(futures) do
    if time <= os.time() then
      futures[fn] = nil
      fn()
    end
  end
end
