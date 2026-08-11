-- Ludo WezTerm — Catppuccin Frappé (match kitty frappe.conf + dank-tabs.conf)
local wezterm = require("wezterm")

return {
  check_for_updates = false,
  window_close_confirmation = "NeverPrompt",
  enable_wayland = true,

  -- Font: fallback automatique, plus besoin de symbol_map
  font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
    "Symbola",
    "Noto Color Emoji",
    "Segoe UI Emoji",
    "Noto Sans CJK JP",
  }),
  font_size = 12.0,

  -- Window
  window_padding = {
    left = 12,
    right = 12,
    top = 12,
    bottom = 12,
  },
  window_background_opacity = 1.0,
  window_decorations = "NONE",

  -- Cursor
  default_cursor_style = "SteadyBlock",
  cursor_blink_rate = 1000,

  -- Scrollback
  scrollback_lines = 3000,

  -- Tab bar: powerline style matching dank-tabs.conf
  enable_tab_bar = true,
  tab_bar_at_bottom = false,
  use_fancy_tab_bar = false,
  tab_max_width = 40,

  -- Colors: Catppuccin Frappe (from frappe.conf)
  colors = {
    foreground = "#c6d0f5",
    background = "#303446",
    cursor_bg = "#f2d5cf",
    cursor_border = "#f2d5cf",
    cursor_fg = "#303446",
    selection_fg = "#303446",
    selection_bg = "#ca9ee6",
    scrollbar_thumb = "#414559",
    split = "#292c3c",

    -- ANSI
    ansi = {
      "#626880", -- 0 black
      "#e78284", -- 1 red
      "#a6d189", -- 2 green
      "#e5c890", -- 3 yellow
      "#8caaee", -- 4 blue
      "#f4b8e4", -- 5 magenta
      "#99d1db", -- 6 cyan
      "#d5d5d8", -- 7 white
    },
    brights = {
      "#737994", -- 8 bright black
      "#ea999c", -- 9 bright red
      "#a6d189", -- 10 bright green
      "#e5c890", -- 11 bright yellow
      "#8caaee", -- 12 bright blue
      "#f4b8e4", -- 13 bright magenta
      "#99d1db", -- 14 bright cyan
      "#c6d0f5", -- 15 bright white
    },

    -- Tab bar (dank-tabs.conf)
    tab_bar = {
      background = "#292c3c",
      active_tab = {
        bg_color = "#ca9ee6",
        fg_color = "#303446",
        intensity = "Bold",
      },
      inactive_tab = {
        bg_color = "#414559",
        fg_color = "#c6d0f5",
        intensity = "Normal",
      },
      inactive_tab_hover = {
        bg_color = "#414559",
        fg_color = "#c6d0f5",
      },
      new_tab = {
        bg_color = "#303446",
        fg_color = "#c6d0f5",
      },
      new_tab_hover = {
        bg_color = "#ca9ee6",
        fg_color = "#303446",
      },
    },
  },
}
