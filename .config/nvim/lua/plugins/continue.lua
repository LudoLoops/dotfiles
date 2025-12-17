return {
  "continuedev/continue",
  build = "cd continue-ui && npm install && npm run build",
  dependencies = {
    "rcarriga/nvim-notify",
  },
  event = "VeryLazy",
  config = function()
    require("continue").setup({
      enable_telemetry = false,
      database = {
        "sqlite",
      },
      allow_anonymous_telemetry = false,
    })
  end,
}
