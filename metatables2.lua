print("nil", getmetatable(nil))
print("boolean", getmetatable(true))
print("number", getmetatable(1))
print("string", getmetatable("test"))

print("table", getmetatable({}))
local function fn()
end
print("function", getmetatable(fn))
print("userdata", "?")
local t = coroutine.create(fn)
print("thread", getmetatable(t))
