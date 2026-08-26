-- Optional per-user keybind overrides (managed by DMS). Loaded after default binds.
-- Binds Mango WM reportés sur Hyprland (muscle memory) — source : ~/.config/mango/dms/binds.conf
-- Ce fichier est chargé APRÈS dms/binds.lua : en cas de conflit, ces binds gagnent.

-- === Navigation bureaux (Mango : viewtoleft / viewtoright) ===
-- Override DMS : SUPER+W était "toggle group"
hl.bind("SUPER + W", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + S", hl.dsp.focus({ workspace = "e+1" }))

-- === Focus fenêtres, style Mango A/D (en plus des flèches et H/J/K/L) ===
hl.bind("SUPER + A", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + D", hl.dsp.focus({ direction = "r" }))

-- === Changement d'écran (Mango : Super+Shift+flèches = focusmon) ===
-- Override DMS : SUPER+SHIFT+flèches était "move window"
hl.bind("SUPER + SHIFT + left", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.focus({ monitor = "r" }))
hl.bind("SUPER + SHIFT + A", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + SHIFT + D", hl.dsp.focus({ monitor = "r" }))

-- === Envoyer la fenêtre sur l'autre écran (Mango : Super+Ctrl+flèches = tagmon) ===
-- Override DMS : SUPER+CTRL+flèches était "focus monitor"
hl.bind("SUPER + CTRL + left", hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + CTRL + right", hl.dsp.window.move({ monitor = "r" }))

-- === Déplacer la fenêtre vers le bureau N sans le suivre (Mango : Super+Alt+N = tagsilent) ===
hl.bind("SUPER + ALT + 1", hl.dsp.window.move({ workspace = "1", follow = false }))
hl.bind("SUPER + ALT + 2", hl.dsp.window.move({ workspace = "2", follow = false }))
hl.bind("SUPER + ALT + 3", hl.dsp.window.move({ workspace = "3", follow = false }))
hl.bind("SUPER + ALT + 4", hl.dsp.window.move({ workspace = "4", follow = false }))
hl.bind("SUPER + ALT + 5", hl.dsp.window.move({ workspace = "5", follow = false }))
hl.bind("SUPER + ALT + 6", hl.dsp.window.move({ workspace = "6", follow = false }))
hl.bind("SUPER + ALT + 7", hl.dsp.window.move({ workspace = "7", follow = false }))
hl.bind("SUPER + ALT + 8", hl.dsp.window.move({ workspace = "8", follow = false }))
hl.bind("SUPER + ALT + 9", hl.dsp.window.move({ workspace = "9", follow = false }))
