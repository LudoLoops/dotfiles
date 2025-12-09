# =============================================================================
# Editor Configuration & Launchers
# =============================================================================
# Nvim editor launcher

# Nvim Editor Launcher
# Launches Neovim in the current terminal
# Usage: v [path] → opens path or current directory in nvim
function v
    if count $argv >/dev/null
        nvim $argv
    else
        nvim .
    end
end
