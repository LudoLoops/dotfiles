-- local function get_relative_path(full_path, cwd)
--   return vim.fn.fnamemodify(full_path, ":~:.") -- Convert full path to relative path
-- end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",

    opts = {
      -- popup_border_style = "rounded",
      window = {
        position = "right",
        width = 30,
        mappings = {
          ["x"] = "close_node",
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
        },
        filesystem = {
          components = {},
        },
      },
    },
  },
}
