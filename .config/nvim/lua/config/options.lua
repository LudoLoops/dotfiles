-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.wrap = true

-- Affiche automatiquement les diagnostics lorsqu'il y a une erreur sous le curseur après une petite pause
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { scope = "cursor" })
  end,
  desc = "Affiche automatiquement les diagnostics sous le curseur",
})

-- Optionnel : Ajuster le délai avant déclenchement (par défaut c'est à 4000 ms)
vim.o.updatetime = 1000 -- Délai de 1000 ms avant que 'CursorHold' soit déclenché
