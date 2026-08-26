# .config/hypr — Config Hyprland (TufTux)

## Structure effective

- `hyprland.conf` — config principale **autonome** : monitors, input, general,
  decoration, animations, windowrules (inline). Source uniquement `dms/*.conf`.
- `dms/` — fragments sourcés par hyprland.conf (binds, outputs, colors, layout,
  cursor) pour DMS (DankMaterialShell) sur Hyprland.
- `bin/hypr-toggle-edp` — script perso : active/désactive l'écran eDP-1 via
  hyprctl, état dans `$XDG_STATE_HOME/hypr/edp_disabled`.
- `monitors.conf`, `nvidia.conf`, `userprefs.conf`, `hyprpaper.conf` —
  **non sourcés** par hyprland.conf (référence historique, valeurs perso).

## Historique

- Mars 2026 : setup HyDE (keybindings, workflows, themes, hyprlock themes…).
- Avril 2026 : passage à Mango WM, config Hyprland simplifiée + DMS.
- Août 2026 : HyDE entièrement supprimé (données + templates dotfiles).
  Hyprland 0.56.2, validé via `Hyprland --verify-config` → config ok.

## Règles

- Après toute modif : `Hyprland --verify-config` (0 erreur requis).
- Le lock/idle est géré par DMS (pas hypridle/hyprlock, service masqué).
- Commit + push après modif (repo dotfiles, GNU Stow).

