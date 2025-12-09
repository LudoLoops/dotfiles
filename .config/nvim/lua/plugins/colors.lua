-- Color scheme and syntax highlighting configuration
return {
  -- Tokyo Night theme (modern and visually appealing)
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night", -- Available: "storm", "moon", "night", "day"
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { bold = false },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
    },
  },

  -- Gruvbox theme (warm and comfortable)
  {
    "morhetz/gruvbox",
    lazy = true,
  },

  -- Catppuccin theme (modern and cohesive)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      show_end_of_buffer = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        mason = true,
        neotree = true,
        notify = true,
        telescope = true,
        treesitter = true,
      },
    },
  },

  -- Kanagawa theme (Japanese-inspired, warm and elegant)
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
  },

  -- LazyVim configuration
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- Enhanced syntax highlighting with Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
  },

  -- Rainbow brackets and context
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Illumination of the word under the cursor
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
}
