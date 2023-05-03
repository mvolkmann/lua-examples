message = "Hello from Lua!"

if os.getenv("NODE_ENV") == "production" then
  color = "red"
else
  color = "green"
end

function demo()
  print("config.lua: demo called")
end
