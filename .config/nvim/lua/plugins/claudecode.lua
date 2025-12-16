return {
  "coder/claudecode.nvim",
  event = "VeryLazy",
  config = function()
    require("claudecode").setup()
  end,
}
