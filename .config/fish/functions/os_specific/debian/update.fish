# System Update - Debian/Ubuntu
# Updates Debian packages via apt

function update
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

    echo "✅ System update complete"
end
