return {
  "stevearc/oil.nvim",
  opts = {

    view_options = {
      -- show_hidden = true,
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Open parent directory (oil)" },
  },
}
