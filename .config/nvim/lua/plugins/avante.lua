-- Configure avante.nvim to use GLM via Anthropic-compatible endpoint
-- Requires API key set in environment

return {
  "yetone/avante.nvim",
  opts = {
    provider = "claude",
    claude = {
      endpoint = "https://api.z.ai/api/anthropic",
      model = "glm-4.7",
      temperature = 0,
      max_tokens = 131072,
    },
  },
}
