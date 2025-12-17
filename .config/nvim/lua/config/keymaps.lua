-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Completion trigger with Space+.
vim.keymap.set("i", "<Space>.", function()
  local cmp = require("cmp")
  if cmp.visible() then
    cmp.close()
  else
    cmp.complete()
  end
end, { desc = "Toggle completion" })
