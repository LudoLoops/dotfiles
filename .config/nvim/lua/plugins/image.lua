-- Image support for Neovim with Kitty terminal integration
return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      backend = "kitty",
      kitty_method = "protocol",
      integrations = {
        markdown = {
          enabled = true,
          sizing_strategy = "auto",
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        html = {
          enabled = true,
        },
        css = {
          enabled = false,
        },
      },
      max_width = 100,
      max_height = 30,
      max_width_window_percentage = 80,
      max_height_window_percentage = 80,
      window_overlap_clear = {
        enable = true,
        ft_ignore = { "cmp_menu", "cmdline", "noice" },
      },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      hijack_file_types = { "png", "jpg", "jpeg", "gif", "webp" },
    },
    config = function(_, opts)
      require("image").setup(opts)
    end,
  },
}
