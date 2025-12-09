# =============================================================================
# Editor Configuration & Launchers
# =============================================================================
# Neovide GUI editor, Zeditor configuration

# Neovide Helper - Launch detached Neovide instance
function __launch_detached
    nohup $argv >/dev/null 2>&1 &
    set pid $last_pid
    disown $pid
end

# Neovide GUI Editor Launcher
# Launches Neovide (NeoVim GUI) in detached mode
# Usage: v [path] → opens path or current directory
function v
    if count $argv >/dev/null
        __launch_detached neovide $argv
    else
        __launch_detached neovide .
    end
end

# Alias for neovide shortcut
alias neovide='v'
