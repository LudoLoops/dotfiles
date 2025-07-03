-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.wrap = true

-- Automatically show diagnostics when there's an error under the cursor after a short pause
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { scope = "cursor" })
  end,
  desc = "Automatically show diagnostics under the cursor",
})

-- Optional: Adjust the delay before triggering (default is 4000 ms)
vim.o.updatetime = 1000 -- Delay of 1000 ms before 'CursorHold' is triggered
