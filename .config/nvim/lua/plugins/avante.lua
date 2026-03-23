-- Configure avante.nvim to use GLM via Anthropic-compatible endpoint
-- Requires API key set in environment

return {
  "yetone/avante.nvim",
  opts = {
    provider = "claude",
    providers = {
      claude = {
        endpoint = "https://api.z.ai/api/anthropic",
        model = "glm-4.7",
        extra_request_body = {
          temperature = 0,
          max_tokens = 131072,
        },
      },
    },
    acp_providers = {
      ["claude-code"] = {
        command = "npx",
        args = { "@zed-industries/claude-code-acp" },
        env = {
          NODE_NO_WARNINGS = "1",
          ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
        },
      },
    },
  },
}
