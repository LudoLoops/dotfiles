# System Update - Arch Linux
# Updates Arch Linux packages, clears cache, and updates Flatpak

function update
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

    echo "✅ System update complete"
end
