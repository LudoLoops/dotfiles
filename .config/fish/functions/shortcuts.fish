# =============================================================================
# Editor & Keyboard Shortcuts
# =============================================================================
# Quick launchers for editors and navigation tools

# Nvim Editor Launcher
# Launches Neovim in the current terminal
# Usage: v [path] → opens path or current directory in nvim
function v
    require nvim neovim
    or return 1

    if count $argv >/dev/null
        nvim $argv
    else
        nvim .
    end
end

# Future shortcuts can be added here
# Examples:
# - zc: Cursor + zoxide navigation
# - zz: Zeditor + zoxide navigation
# - Other editor launchers
