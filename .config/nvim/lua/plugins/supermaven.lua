return {
  "supermaven-inc/supermaven-nvim",
  event = "VeryLazy",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        next_suggestion = "<C-]>",
      },
      ignore_filetypes = { "bigfile", "svn", "cvs" },
      disable_inline_completion = false,
      disable_indexing = false,
      log_level = "info",
    })
  end,
}
