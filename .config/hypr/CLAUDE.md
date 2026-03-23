# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Hyprland Wayland compositor configuration using the HyDE (Hyprland Desktop Environment) framework. Configuration is split across multiple sourced files for modularity.

### Core Configuration Flow

1. **Entry point**: `hyprland.conf` sources other configs in order:
   - `keybindings.conf` - User keybindings (overridden by config/keybinds.conf)
   - `windowrules.conf` - Window behavior rules
   - `monitors.conf` - Monitor and workspace layout
   - `userprefs.conf` - Input, gestures, misc settings
   - `config/autostart.conf` - Autostart applications

2. **HyDE integration**: Falls back to `$HOME/.local/share/hyde/hyprland.conf` when `HYPRLAND_CONFIG` is not set. The `$HYDE_HYPRLAND=set` marker prevents HyDE from overwriting user configs.

3. **Workflows**: `workflows.conf` sets the active workflow (default, gaming, powersaver, etc.). Workflows in `workflows/` directory contain preset configurations for different use cases.

### Directory Structure

```
.config/hypr/
├── hyprland.conf          # Main entry point
├── userprefs.conf         # Personal overrides (input, gestures, misc)
├── keybindings.conf       # User keybindings
├── monitors.conf          # Monitor & workspace config
├── workflows.conf         # Active workflow selector
├── hypridle.conf          # Idle/lock/suspend configuration
├── hyprlock.conf          # Lock screen configuration
├── themes/                # Color schemes and theme configs
├── animations/            # Animation presets
├── workflows/             # Workflow presets
├── shaders/               # Fragment shaders for visual effects
├── hyprlock/              # Lock screen style presets
├── bin/                   # Helper scripts (e.g., hypr-toggle-edp)
└── config/                # HyDE-managed configs
    ├── autostart.conf
    ├── keybinds.conf      # Overrides keybindings.conf
    ├── monitor.conf
    └── ...
```

## Commands

### Reload Configuration

```bash
# Full config reload (works for most changes)
hyprctl reload
```

### Monitor Management

```bash
# Toggle laptop display (eDP-1) on/off
~/.config/hypr/bin/hypr-toggle-edp

# Or keybind: Super+P
# State stored in $XDG_STATE_HOME/hypr/edp_disabled
```

### Theme and Style

```bash
# These are typically launched via HyDE's hyde-shell wrapper:
hyde-shell wallpaper -Gn      # Next wallpaper
hyde-shell themeselect         # Select theme
hyde-shell animations --select # Select animation preset
hyde-shell hyprlock --select   # Select lock screen style
```

### Testing Changes

Monitor config changes require `hyprctl reload`. Some changes (like keybinds) take effect immediately. Waybar reloads automatically when style changes.

## Key Patterns

### Monitor Configuration

- `monitors.conf` contains both fallback (`monitor = ,preferred,auto,1`) and specific monitor setups
- Workspaces 1-5 assigned to HDMI-A-1 (external), 6-10 to eDP-1 (laptop)
- Use `hyprctl keyword monitor "<config>"` for runtime changes

### Dual Monitor Toggle Script

The `bin/hypr-toggle-edp` script uses a state file (`$XDG_STATE_HOME/hypr/edp_disabled`) to track laptop display state. When toggling off, it disables eDP-1. When toggling on, it reapplies the full layout from hardcoded values.

### HyDE Integration

- Lines with `#!` markers are HyDE-controlled and may be overwritten
- `$HYDE_HYPRLAND=set` in hyprland.conf prevents HyDE overwrites
- Many commands use `hyde-shell` wrapper for unified interface to HyDE tools

### Keybinding Groups

Keybindings use the `$d` variable for grouping/organization (visible in GUI tools). Groups include:
- Window Management, Launcher, Hardware Controls, Utilities, Theming, Workspaces
- Both `keybindings.conf` and `config/keybinds.conf` are sourced; the latter overrides

## Notes

- Configuration is for Arch Linux with Wayland (Hyprland)
- Uses Fish shell 3.6+ for scripts (see ../../AGENTS.md for fish patterns)
- Theme colors in `themes/colors.conf` use wallbash variables
- NVIDIA config (`nvidia.conf`) available but conditionally used
