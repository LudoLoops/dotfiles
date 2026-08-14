-- Ludo WezTerm — Catppuccin Frappé/Latte auto (match kitty + Zed system theme)
local wezterm = require("wezterm")

-- Palette switcher: dark = Frappé, light = Latte
local function colors_for(appearance)
  if appearance:find("Dark") then
    -- Catppuccin Frappé (from frappe.conf)
    return {
      foreground = "#c6d0f5",
      background = "#303446",
      cursor_bg = "#f2d5cf",
      cursor_border = "#f2d5cf",
      cursor_fg = "#303446",
      selection_fg = "#303446",
      selection_bg = "#ca9ee6",
      scrollbar_thumb = "#414559",
      split = "#292c3c",
      ansi = {
        "#626880", "#e78284", "#a6d189", "#e5c890",
        "#8caaee", "#f4b8e4", "#99d1db", "#d5d5d8",
      },
      brights = {
        "#737994", "#ea999c", "#a6d189", "#e5c890",
        "#8caaee", "#f4b8e4", "#99d1db", "#c6d0f5",
      },
      tab_bar = {
        background = "#292c3c",
        active_tab = { bg_color = "#ca9ee6", fg_color = "#303446", intensity = "Bold" },
        inactive_tab = { bg_color = "#414559", fg_color = "#c6d0f5", intensity = "Normal" },
        inactive_tab_hover = { bg_color = "#414559", fg_color = "#c6d0f5" },
        new_tab = { bg_color = "#303446", fg_color = "#c6d0f5" },
        new_tab_hover = { bg_color = "#ca9ee6", fg_color = "#303446" },
      },
    }
  else
    -- Catppuccin Latte (light, match Zed light theme)
    return {
      foreground = "#4c4f69",
      background = "#eff1f5",
      cursor_bg = "#dc8a78",
      cursor_border = "#dc8a78",
      cursor_fg = "#eff1f5",
      selection_fg = "#eff1f5",
      selection_bg = "#8839ef",
      scrollbar_thumb = "#bcc0cc",
      split = "#e6e9ef",
      ansi = {
        "#5c5f77", "#d20f39", "#40a02b", "#df8e1d",
        "#1e66f5", "#d20f39", "#179299", "#acb0be",
      },
      brights = {
        "#6c6f85", "#d20f39", "#40a02b", "#df8e1d",
        "#1e66f5", "#ea76cb", "#179299", "#4c4f69",
      },
      tab_bar = {
        background = "#e6e9ef",
        active_tab = { bg_color = "#8839ef", fg_color = "#eff1f5", intensity = "Bold" },
        inactive_tab = { bg_color = "#ccd0da", fg_color = "#4c4f69", intensity = "Normal" },
        inactive_tab_hover = { bg_color = "#ccd0da", fg_color = "#4c4f69" },
        new_tab = { bg_color = "#eff1f5", fg_color = "#4c4f69" },
        new_tab_hover = { bg_color = "#8839ef", fg_color = "#eff1f5" },
      },
    }
  end
end

return {
  check_for_updates = false,
  window_close_confirmation = "NeverPrompt",
  skip_close_confirmation_for_processes_named = { "herdr", "fish", "ssh" },
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
  enable_tab_bar = false,
  tab_bar_at_bottom = false,
  use_fancy_tab_bar = false,
  tab_max_width = 40,
  -- Colors: auto dark/light following system theme
  colors = colors_for(wezterm.gui.get_appearance()),
}
