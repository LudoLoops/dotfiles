return {
  "folke/lazy.nvim",
  event = "VeryLazy",
  init = function()
    -- Configuration des couleurs Tokyo Night
    local mode_colors = {
      --
      normal = "009696", -- Bleu violet Tokyo Night
      insert = "00942F", -- vert
      visual = "7D0099", -- Violet/MauvVe
      command = "962800", -- Orange/Ambre
      replace = "FF0066",
    }

    -- Fonction pour changer la couleur
    local function set_keyboard_color(color)
      vim.fn.system("asusctl led-mode static -c " .. color)
    end

    -- Créer le groupe d'autocommandes
    local group = vim.api.nvim_create_augroup("KeyboardRGB", { clear = true })

    -- Autocommande pour les changements de mode
    vim.api.nvim_create_autocmd("ModeChanged", {
      group = group,
      pattern = "*",
      callback = function()
        local current_mode = vim.api.nvim_get_mode().mode
        local color = mode_colors.normal

        if current_mode == "i" then
          color = mode_colors.insert
        elseif current_mode:match("^[vV\22]") then
          color = mode_colors.visual
        elseif current_mode == "R" then
          color = mode_colors.replace
        elseif current_mode == "c" then
          color = mode_colors.command
        end

        set_keyboard_color(color)
      end,
    })

    -- Restaurer la couleur par défaut en quittant
    vim.api.nvim_create_autocmd("VimLeave", {
      group = group,
      callback = function()
        set_keyboard_color(mode_colors.normal)
      end,
    })
  end,
}
