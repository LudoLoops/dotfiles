-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  -- Helper function for transparency formatting
  local alpha = function()
    return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
  end
  -- g:neovide_opacity should be 0 if you want to unify transparency of content and title bar.
  vim.g.neovide_opacity = 0.7
  vim.g.transparency = 0.7
  vim.g.neovide_background_color = "#0f1117" .. alpha()
end
