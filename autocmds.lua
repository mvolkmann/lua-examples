local group = vim.api.nvim_create_augroup("my-group", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  -- Only run when one of these file types is opened.
  -- To run for all file types, use "*".
  pattern = { "javascript", "lua", "text" },
  callback = function()
    -- vim.schedule is like setImmediate in JavaScript.
    -- defer_fn is like setTimeout in JavaScript.
    -- vim.wait is like setInterval in JavaScript.
    vim.defer_fn(function()
      print("I was deferred.")
    end, 1000) -- milliseconds

    -- See ":h expand" for a list of available data.
    local data = {
      buf = vim.fn.expand("<abuf>"),    -- buffer number
      file = vim.fn.expand("<afile>"),  -- file name
      match = vim.fn.expand("<amatch>") -- matched file type
    }
    vim.print(data)
  end
})
