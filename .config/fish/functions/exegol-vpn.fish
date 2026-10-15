function exegol-vpn --description "Manage Exegol VPN profiles"
    set -l base "$HOME/1Dev/pentest/vpn"
    set -l library "$base/library"

    if not test -d "$library"
        echo "Library not found: $library"
        return 1
    end

    if test (count $argv) -lt 2
        echo "Active VPNs:"
        for file in $base/*.ovpn
            echo "  "(path basename "$file")
        end

        echo ""
        echo "Library:"
        for file in $library/*.ovpn
            echo "  "(path basename "$file")
        end

        echo ""
        echo "Usage: exegol-vpn <container> <profile>"
        return 0
    end

    if test (count $argv) -ne 2
        echo "Usage: exegol-vpn <container> <profile>"
        return 1
    end

    set -l container $argv[1]
    set -l profile $argv[2]

    if not string match -qr '^[a-zA-Z0-9_-]+$' -- "$container"
        echo "Invalid container name"
        return 1
    end

    if not string match -qr '^[a-zA-Z0-9_-]+$' -- "$profile"
        echo "Invalid profile name"
        return 1
    end

    set -l source "$library/$profile.ovpn"
    set -l target "$base/$container.ovpn"

    if not test -f "$source"
        echo "Profile not found: $profile"
        return 1
    end

    # Preserve the existing file when possible

    command cp -- "$source" "$target"
    or return 1

    chmod 600 "$target"
    or return 1

    echo "VPN configured: $container -> $profile"

end
