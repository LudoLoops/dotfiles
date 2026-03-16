-- Configure rainbow-delimiters highlights to match kanagawa theme

-- Define kanagawa-inspired highlight groups
local highlights = {
  RainbowDelimiterViolet = { fg = "#957FB8" },  -- oniViolet
  RainbowDelimiterCyan = { fg = "#7FB4CA" },    -- springBlue
  RainbowDelimiterGreen = { fg = "#98BB6C" },   -- springGreen
  RainbowDelimiterOrange = { fg = "#FFA066" },  -- surimiOrange
  RainbowDelimiterRed = { fg = "#E46876" },     -- waveRed
  RainbowDelimiterYellow = { fg = "#E6C384" },  -- carpYellow
  RainbowDelimiterBlue = { fg = "#7E9CD8" },    -- crystalBlue
}

-- Apply highlights
for group, hl in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, hl)
end
