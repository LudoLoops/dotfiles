return {
  "supermaven-ai/supermaven-nvim",
  event = "VeryLazy",
  config = function()
    require("supermaven-ai.supermaven-nvim").setup({
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
