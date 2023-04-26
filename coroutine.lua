local n = 0

-- We only need to pass arguments in the
-- first call to `resume` for this coroutine.
local thread = coroutine.create(function(delta, limit)
  while true do
    local next = n + delta
    if next > limit then break end
    n = next
    coroutine.yield(n)
  end
end)

print(type(thread))             -- thread

print(coroutine.status(thread)) -- "suspended"

local success, v = coroutine.resume(thread, 3, 15)
while success and v do
  print(v) -- 3, 6, 9, 12, and 15
  success, v = coroutine.resume(thread)
end

print(coroutine.status(thread)) -- "dead"
