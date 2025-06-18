return {
  -- {
  --   "wuelnerdotexe/vim-astro",
  -- },
  {
    "knubie/vim-kitty-navigator",
  },
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
    lazy = false,
  },

  -- display image in vim
  -- {
  --   "3rd/image.nvim",
  --   config = function()
  --     -- ...
  --   end,
  -- },
  -- {
  --   "vhyrro/luarocks.nvim",
  --   priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
  --   config = true,
  --   opts = {
  --     rocks = { "magick" },
  --   },
  -- },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = { accept_suggestion = "<C-g>", "accept suggestion" },
      })
    end,
  },
  -- {
  --   "Exafunction/codeium.vim",
  --   event = "BufEnter",
  --   config = function()
  --     -- Change '<C-g>' here to any keycode you like.
  --     vim.keymap.set("i", "<C-g>", function()
  --       return vim.fn["codeium#Accept"]()
  --     end, { expr = true, silent = true })
  --     vim.keymap.set("i", "<C-;>", function()
  --       return vim.fn["codeium#CycleCompletions"](1)
  --     end, { expr = true, silent = true })
  --     vim.keymap.set("i", "<C-,>", function()
  --       return vim.fn["codeium#CycleCompletions"](-1)
  --     end, { expr = true, silent = true })
  --     vim.keymap.set("i", "<C-x>", function()
  --       return vim.fn["codeium#Clear"]()
  --     end, { expr = true, silent = true })
  --   end,
  -- },
  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = true,
      keymaps = {
        ["h"] = "actions.toggle_hidden",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- {
  --   "chrisgrieser/nvim-spider",
  --
  --   keys = {
  --     {
  --       "e",
  --       "<cmd>lua require('spider').motion('e')<CR>",
  --       mode = { "n", "o", "x" },
  --     },
  --     { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
  --     {
  --       "b",
  --       "<cmd>lua require('spider').motion('b')<CR>",
  --       mode = { "n", "o", "x" },
  --     },
  --   },
  -- },
}
