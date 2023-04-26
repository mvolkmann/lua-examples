function main()
  -- Get the list of URLs to request.
  local urls = {
    "https://www.google.com",
    "https://www.yahoo.com",
    "https://www.bing.com",
  }

  -- Create a table to store the results of the requests.
  local results = {}

  -- Create a thread pool to handle the requests.
  -- TODO: The threadpool library is not in LuaRocks or anywhere!
  local pool = require("threadpool"):new(3)

  -- Send the requests in parallel.
  for _, url in ipairs(urls) do
    pool:add_task(function()
      local response = http.get(url)
      results[url] = response.body
    end)
  end

  -- Wait for all the requests to complete.
  pool:wait()

  -- Print the results.
  for url, body in pairs(results) do
    print(url, body)
  end
end

main()
