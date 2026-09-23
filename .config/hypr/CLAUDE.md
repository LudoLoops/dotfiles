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

## Parité Mango WM (sept. 2026)
- **Clavier** : `input.kb_layout = "us"` + `kb_variant = "altgr-intl"` (= Mango
  `xkb_rules_layout=us` / `xkb_rules_variant=altgr-intl`). Sans variante
  explicite, Hyprland retombe sur `us` simple (XKB_DEFAULT_LAYOUT non défini).
- **Layout** : `general.layout = "scrolling"` (natif depuis 0.54) +
  `scrolling { direction = "right", column_width = 0.5,
  explicit_column_widths = "0.25, 0.5, 0.75, 1.0" }` = Mango `scroller`
  (`scroller_default_proportion`, `scroller_proportion_preset`).
- **Bureaux empilés verticalement** : `hl.animation({ leaf = "workspaces",
  style = "slidevert" })` = `tag_animation_direction=0` côté Mango. Hyprland
  n'a pas de pile de workspaces verticale — l'effet vient de l'animation.
- **Molette dans la fenêtre non active** : `input.follow_mouse = 2` (focus pointeur détaché
  du focus clavier). Avec `0`, Hyprland ne donne jamais le focus pointeur à la fenêtre
  survolée → la molette ne part qu'à la fenêtre focusée. `2` = comportement Mango/dwl
  (molette + survol vers la fenêtre sous le curseur, clic = focus clavier).
- **⚠️ Trackball Kensington SlimBlade Pro — ne PAS réinjecter le preset Input Remapper
  « swap-buttons ».** Il inverse BTN_RIGHT (273) ↔ BTN_SIDE (275) ; une fois injecté, le clic
  ne répond plus (constaté sept. 2026). Aucun hook de démarrage côté Hyprland — celui ajouté
  puis retiré. Arrêter une injection : `input-remapper-control --command stop-all`.
  Pour inverser gauche/droite proprement : `hl.device({ name = "...", left_handed = true })`
  (natif, sans grab ni device virtuel).
- **Correspondance des binds** (tous dans `dms/binds-user.lua`) :
  | Mango | Hyprland |
  |---|---|
  | `focusdir` — Super+flèches, Super+a/d | `hl.dsp.focus({ direction })` |
  | `focusmon` — Super+Shift+flèches/a/d | `hl.dsp.focus({ monitor = "l"/"r" })` |
  | `tagmon` — Super+Ctrl+←/→ | `hl.dsp.window.move({ monitor })` |
  | `exchange_client` — Super+Shift+↑/↓ | `hl.dsp.window.move({ direction })` |
  | `tag`/`tagsilent` — Super+Shift/Alt+1-9 | `hl.dsp.window.move({ workspace })` (`follow=false` pour silent) |
  | `view`/`viewtoleft|right` — Super+1-9, Super+w/s | `hl.dsp.focus({ workspace })` |
  | `switch_proportion_preset` — Super+Ctrl+a/d | `hl.dsp.layout("colresize -conf" / "+conf")` |
  | `focusstack next` — Alt+Tab | `hl.dsp.window.cycle_next({ next = true })` |
- **Lanceurs** (parité Mango) : `Super+T` = wezterm, `Super+B` = zen-browser,
  `Super+E` = dolphin, `Super+O` = obsidian. Binds Hyprland en conflit déplacés :
  ghostty (`Super+T`) → **Super+Return**, overview (`Super+O`) → **Super+Z**
  (= touche overview de Mango ; `Super+Tab` reste aussi).
- **Écarts assumés** : `resizewin` (Mango Super+Shift+Ctrl+↑/↓) tombe sur
  « fenêtre vers l'écran ↑/↓ » dans Hyprland — le resize est sur
  Super+Shift+minus/equal, et la largeur de colonne sur Super+Ctrl+A/D.

## Historique
- Mars 2026 : setup HyDE. Avril 2026 : migration Mango WM + DMS.
- Août 2026 : HyDE supprimé, retour Hyprland 0.56.2 (config seule + DMS).
- Août 2026 : config migrée .conf → .lua (DMS), binds Mango reportés.
- Sept 2026 : parité Mango complète — clavier us/altgr-intl, scrolling par
  défaut + bureaux verticaux (`slidevert`), binds de déplacement manquants.

## Règles
- Après toute modif : `Hyprland --verify-config` (0 erreur requis).
- Reload à chaud : `hyprctl reload` (avec HYPRLAND_INSTANCE_SIGNATURE si SSH).
- Lock/idle/wallpaper gérés par DMS (hypridle masqué, hyprpaper non lancé).
- Commit + push après modif (repo dotfiles, GNU Stow).
