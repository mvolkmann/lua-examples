local socket = require "socket"

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

function getCenter(points)
  local minX = points[1]
  local minY = points[2]
  local maxX = minX
  local maxY = minY

  for i = 3, #points, 2 do
    local x = points[i]
    local y = points[i + 1]
    if x < minX then minX = x end
    if x > maxX then maxX = x end
    if y < minY then minY = y end
    if y > maxY then maxY = y end
  end

  return (minX + maxX) / 2, (minY + maxY) / 2
end

local laters = {}

-- This schedules a function to run in the later.
function later(fn, seconds)
  -- os.time() only returns the time in seconds as an integer.
  -- socket.gettime() is similar but returns
  -- a floating point value for subsecond precision.
  laters[fn] = socket.gettime() + seconds
end

-- Call this near the beginning of love.update.
function processLaters()
  for fn, time in pairs(laters) do
    if time <= os.time() then
      laters[fn] = nil
      fn()
    end
  end
end
