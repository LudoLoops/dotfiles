# =============================================================================
# Dependency Helper
# =============================================================================
# Ensures required programs are installed, offers to install if missing

# Helper function to check and install missing programs
# Usage: ensure_installed <program> [arch_package] [debian_package]
# If arch_package is not provided, uses program name
# If debian_package is not provided, uses arch_package name
# Returns: 0 if installed, 1 if failed
function ensure_installed --argument program arch_package debian_package
    # Use program name as default package name
    set pkg (if test -n "$arch_package"; echo $arch_package; else; echo $program; end)

    # Skip check if program is found
    if command -v $program >/dev/null 2>&1
        return 0
    end

    # Program not found
    echo "❌ $program not found"

    # Detect OS and show install command
    if test -f /etc/arch-release
        set install_cmd "paru -S $pkg"
        echo "💡 Install: $install_cmd"
    else if test -f /etc/debian_version
        set debian_pkg (if test -n "$debian_package"; echo $debian_package; else; echo $pkg; end)
        set install_cmd "sudo apt install $debian_pkg"
        echo "💡 Install: $install_cmd"
    else
        echo "⚠️  Unsupported OS, please install $program manually"
        return 1
    end

    # Ask if user wants to install now
    read -l -P "Install now? [y/N] " answer
    if string match -qi y $answer
        if test -f /etc/arch-release
            paru -S $pkg
        else if test -f /etc/debian_version
            sudo apt install $debian_pkg
        end

        # Check if installation succeeded
        if command -v $program >/dev/null 2>&1
            echo "✅ $program installed successfully"
            return 0
        else
            echo "❌ Failed to install $program"
            return 1
        end
    else
        return 1
    end
end

# Require program or exit function
# Usage: require <program> [arch_package] [debian_package]
# Automatically returns 1 if not installed, no need for "or return 1"
function require
    ensure_installed $argv
    or return 1
end

# Silent version (no prompt, just check)
function has_program --argument program
    command -v $program >/dev/null 2>&1
end
