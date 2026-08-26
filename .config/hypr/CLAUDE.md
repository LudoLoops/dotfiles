# .config/hypr — Config Hyprland (TufTux)

## Structure
- `hyprland.lua` — config principale (Lua, Hyprland 0.55+) : input, general,
  decoration, animations, windowrules (inline). Require les modules `dms/*.lua`.
- `dms/` — fragments sourcés pour DMS (DankMaterialShell) :
  - `binds.lua` — binds par défaut DMS
  - `binds-user.lua` — overrides perso (chargés EN DERNIER = priorité).
    Contient les raccourcis Mango WM (Super+W/S bureaux, Super+Alt+1-9, etc.)
  - `outputs.lua`, `colors.lua`, `layout.lua`, `cursor.lua`, `windowrules.lua`
- `bin/hypr-toggle-edp` — script perso : toggle eDP-1 via hyprctl,
  état dans `$XDG_STATE_HOME/hypr/edp_disabled`.
Tout le reste (wallpaper, idle, lock, notifications, bar) = DMS.

## Syntaxe binds Lua
`hl.bind("SUPER + W", hl.dsp.focus({ workspace = "e-1" }))` — le dernier
bind enregistré sur une même touche gagne (binds-user.lua gagne sur binds.lua).

## Historique
- Mars 2026 : setup HyDE. Avril 2026 : migration Mango WM + DMS.
- Août 2026 : HyDE supprimé, retour Hyprland 0.56.2 (config seule + DMS).
- Août 2026 : config migrée .conf → .lua (DMS), binds Mango reportés.

## Règles
- Après toute modif : `Hyprland --verify-config` (0 erreur requis).
- Reload à chaud : `hyprctl reload` (avec HYPRLAND_INSTANCE_SIGNATURE si SSH).
- Lock/idle/wallpaper gérés par DMS (hypridle masqué, hyprpaper non lancé).
- Commit + push après modif (repo dotfiles, GNU Stow).
