-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  vim.cmd("highlight Normal guibg=#141A21")
  vim.cmd("highlight NormalNC guibg=#141A21")
end
