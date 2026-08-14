-- Ludo WezTerm — Catppuccin Frappé/Latte auto (match kitty + Zed system theme)
local wezterm = require("wezterm")

-- Palettes nommées : Frappé (dark) / Latte (light)
local schemes = {
  ["Ludo Frappé"] = {
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
  },
  ["Ludo Latte"] = {
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
  },
}

-- Auto dark/light suivant le thème système (même signal que Zed)
local function scheme_for(appearance)
  if appearance:find("Dark") then
    return "Ludo Frappé"
  end
  return "Ludo Latte"
end

-- Zap et sélecteur gérés plus bas (après construction de scheme_choices)

local scheme_choices = {}
for name, _ in pairs(wezterm.color.get_builtin_schemes()) do
  table.insert(scheme_choices, { label = name })
end
table.sort(scheme_choices, function(a, b) return a.label < b.label end)

-- Zap de thèmes : Ctrl+Shift+J (suivant) / Ctrl+Shift+K (précédent)
-- Aperçu instantané, nom affiché dans le titre de la fenêtre
local scheme_idx = nil

local function cycle_scheme(window, dir)
  if scheme_idx == nil then
    local cur = window:effective_config().color_scheme
    scheme_idx = 1
    for i, c in ipairs(scheme_choices) do
      if c.label == cur then
        scheme_idx = i
        break
      end
    end
  end
  scheme_idx = scheme_idx + dir
  if scheme_idx < 1 then
    scheme_idx = #scheme_choices
  elseif scheme_idx > #scheme_choices then
    scheme_idx = 1
  end
  local name = scheme_choices[scheme_idx].label
  window:set_config_overrides({ color_scheme = name })
  -- Mémorise le choix pour palette-preview (affichage silencieux)
  local f = io.open("/tmp/wezterm-current-theme", "w")
  if f then
    f:write(name)
    f:close()
  end
end

wezterm.on("cycle-scheme-next", function(window) cycle_scheme(window, 1) end)
wezterm.on("cycle-scheme-prev", function(window) cycle_scheme(window, -1) end)

wezterm.on("select-colorscheme", function(window, pane, id, label)
  if label then
    scheme_idx = nil
    window:set_config_overrides({ color_scheme = label })
    local f = io.open("/tmp/wezterm-current-theme", "w")
    if f then
      f:write(label)
      f:close()
    end
  end
end)

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
  -- Colors
  color_schemes = schemes,
  color_scheme = scheme_for(wezterm.gui.get_appearance()),
  keys = {
    {
      key = "U",
      mods = "CTRL|SHIFT",
      action = wezterm.action.InputSelector({
        title = "Color Scheme (fuzzy search)",
        choices = scheme_choices,
        fuzzy = true,
        action = wezterm.action.EmitEvent("select-colorscheme"),
      }),
    },
    { key = "J", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("cycle-scheme-next") },
    { key = "K", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("cycle-scheme-prev") },
    -- Skin Hermes : L = light, D = dark (tape la commande dans la session active)
    { key = "L", mods = "CTRL|SHIFT", action = wezterm.action.SendString "/skin warm-lightmode\r" },
    { key = "D", mods = "CTRL|SHIFT", action = wezterm.action.SendString "/skin slate\r" },
  },
}
