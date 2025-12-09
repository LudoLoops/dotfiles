# =============================================================================
# System Administration & Shell Utilities
# =============================================================================
# Docker, Zoxide, package management, backups, SSH, file exploration

# Docker Service Management
function start_docker
    echo "🚀 Starting Docker service..."
    sudo systemctl start docker
    while not systemctl is-active docker >/dev/null
        echo "⏳ Waiting for Docker to start..."
        sleep 1
    end
    echo "✅ Docker has started"
end

function stop_docker
    echo "🛑 Stopping Docker service..."
    sudo systemctl stop docker
    echo "✅ Docker has stopped"
end

# Docker & Docker Compose Control
function dockcontrol
    switch $argv[1]
        case start
            if not systemctl is-active docker >/dev/null
                start_docker
            end
            echo "🐳 Starting Docker Compose services..."
            docker-compose up -d
            echo "✅ Docker Compose services have started"

        case stop
            echo "🛑 Stopping Docker Compose services..."
            docker-compose down
            stop_docker

        case restart
            echo "🔄 Restarting Docker Compose services..."
            docker-compose down
            docker-compose up -d
            echo "✅ Docker Compose services have restarted"

        case '*'
            echo "Usage: dockcontrol [command]"
            echo "Commands:"
            echo "  start   - Starts Docker and Docker Compose services"
            echo "  stop    - Stops Docker Compose services and Docker"
            echo "  restart - Restarts Docker Compose services"
    end
end

# Zoxide + Cursor integration
# Navigate to directory and open in Cursor editor
function zc
    z $argv && cursor . >/dev/null 2>&1 &
    disown
end

# Zoxide + Zeditor integration
# Navigate to directory and open in Zeditor
function zz --argument path
    if test -n "$path"
        z "$path"
    end
    command zeditor .
end

# System Update
# Updates Arch Linux packages, clears cache, and updates Flatpak
function update
    paru -Syu --noconfirm
    sudo paccache -r
    if type -q flatpak
        flatpak update -y
    end
end

# File Backup Creator
# Creates a backup file by copying original with .bak extension
# Usage: backup file.txt → creates file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

# Yazi File Manager Integration
# Opens Yazi file manager and changes shell directory to selected path
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# SSH Agent Initialization
# Sets up SSH_AUTH_SOCK and loads keys via TPM SSH Agent
function tpm-ssh-init
    # Set SSH_AUTH_SOCK
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

    # Load keys if agent is running
    if test -S "$SSH_AUTH_SOCK"
        ~/.local/bin/tpm-ssh-agent-helper.sh
    end
end
