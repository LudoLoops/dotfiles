# System Update - Multi-OS
# Detects OS and runs appropriate update command

function update
    # Detect OS from /etc/os-release
    set os_id (cat /etc/os-release 2>/dev/null | grep '^ID=' | cut -d'=' -f2 | tr -d '"')

    switch "$os_id"
        case arch cachyos manjaro
            echo "📦 Updating Arch packages..."
            paru -Syu --noconfirm || begin
                echo "❌ Failed to update Arch packages"
                return 1
            end

            echo "🧹 Cleaning package cache..."
            sudo paccache -rk1 || begin
                echo "⚠️  Warning: Failed to clean package cache"
            end

            if type -q flatpak
                echo "📦 Updating Flatpaks..."
                flatpak update -y || begin
                    echo "⚠️  Warning: Failed to update Flatpaks"
                end
            end

        case debian ubuntu
            echo "📦 Updating Debian packages..."
            sudo apt update || begin
                echo "❌ Failed to update package list"
                return 1
            end

            echo "📦 Upgrading packages..."
            sudo apt upgrade -y || begin
                echo "❌ Failed to upgrade packages"
                return 1
            end

        case '*'
            echo "❌ Unsupported OS: $os_id"
            return 1
    end

    echo "✅ System update complete"
end
