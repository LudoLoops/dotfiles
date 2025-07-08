-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_cursor_hack = true
  vim.g.neovide_cursor_vfx_mode = "torpedo"
  vim.opt.guifont = "JetBrainsMono Nerd Font:h13"
  -- vim.cmd("highlight Normal guibg=#141A21")
  -- vim.cmd("highlight NormalNC guibg=#141A21")
end
