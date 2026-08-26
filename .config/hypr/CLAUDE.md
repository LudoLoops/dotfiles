# .config/hypr — Config Hyprland (TufTux)

## Structure

- `hyprland.conf` — config principale autonome : monitors, input, general,
  decoration, animations, windowrules (inline). Source uniquement `dms/*.conf`.
- `dms/` — fragments sourcés (binds, outputs, colors, layout, cursor)
  pour DMS (DankMaterialShell) sur Hyprland.
- `bin/hypr-toggle-edp` — script perso : toggle eDP-1 via hyprctl,
  état dans `$XDG_STATE_HOME/hypr/edp_disabled`.

Tout le reste (wallpaper, idle, lock, notifications, bar) = DMS.

## Historique

- Mars 2026 : setup HyDE. Avril 2026 : migration Mango WM + DMS.
- Août 2026 : HyDE supprimé, retour Hyprland 0.56.2 (config seule + DMS).

## Règles

- Après toute modif : `Hyprland --verify-config` (0 erreur requis).
- Lock/idle/wallpaper gérés par DMS (hypridle masqué, hyprpaper non lancé).
- Commit + push après modif (repo dotfiles, GNU Stow).
