return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      style = "night",
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        compile = false, -- enable compiling the colorscheme
        -- transparent = true, -- do not set background color
        terminalColors = false, -- define vim.g.terminal_color_{0,17}
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            -- Flottants
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },

            -- Fond général
            Normal = { fg = "#a6c7bd", bg = "#141A21" },
            -- CursorLine = { bg = "#1F1F28" },

            -- Composants syntaxiques
            Comment = { fg = "#748b84", italic = true },
            --Identifier = { fg = "#C99359" }, -- variables, parameters
            -- Statement = { fg = "#F2A05C" }, -- if, for, return
            -- Type = { fg = "#0D998A" }, -- int, string, etc.
            -- Constant = { fg = "#C2654A" }, -- numbers, true, false
            -- Keyword = { fg = "#23867C" }, -- function, local, etc.
            -- Function = { fg = "#F2A05C" }, -- function names
            ["@keyword.import"] = { fg = "#70628C" }, -- couleur pour `import`, `from`, etc.
            ["@include"] = { fg = "#70628C" }, -- parfois utilisé aussi
            -- Keyword = { fg = "#23867C" }, -- fallback classique
          }
        end,
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
