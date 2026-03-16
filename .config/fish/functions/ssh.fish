# =============================================================================
# SSH Key Management
# =============================================================================

# Generate new SSH key (ed25519, 100 KDF rounds)
function ssh-new --argument name
    set key_only false

    # Parse flags
    if test "$argv[1]" = "--key-only"
        set key_only true
        set name $argv[2]
    else
        set name $argv[1]
    end

    # ============================================================================
    # TUI: Setup mode selection
    # ============================================================================
    if test "$key_only" = false
        echo
        echo "╭─────────────────────────────────────────────────────────╮"
        echo "│  🔐 SSH Setup                                            │"
        echo "╰─────────────────────────────────────────────────────────╯"
        echo
        echo "  1) Key only      Generate SSH key only"
        echo "  2) Full setup    Key + SSH config entry"
        echo
        read -l -P 'Select mode [1-2]: ' mode

        switch $mode
            case 1
                set key_only true
            case 2
                set key_only false
            case '*'
                echo "❌ Invalid selection"
                return 1
        end
        echo
    end

    # ============================================================================
    # Get key name
    # ============================================================================
    if test -z "$name"
        read -l -P 'Key name: ' name
        if test -z "$name"
            echo "❌ Key name required"
            return 1
        end
    end

    set key_path "$HOME/.ssh/$name"

    # Check if key already exists
    if test -f "$key_path"
        echo "⚠️  Key already exists: $key_path"
        read -l -n1 -p 'echo "Overwrite? [y/N]: "' overwrite
        if not string match -qi 'y' $overwrite
            echo "Aborted."
            return 1
        end
        rm -f "$key_path" "$key_path.pub"
    end

    # ============================================================================
    # Generate SSH key
    # ============================================================================
    echo "🔐 Generating SSH key: $name"
    command ssh-keygen -t ed25519 -a 100 -f "$key_path" -C "$name" -q

    if test $status -ne 0
        echo "❌ Failed to generate SSH key"
        return 1
    end

    echo
    echo "✅ SSH key created!"
    echo "📁 Private: $key_path"
    echo "📁 Public:  $key_path.pub"

    # ============================================================================
    # Setup SSH config entry
    # ============================================================================
    if test "$key_only" = false
        echo
        echo "─── SSH Config Entry ───"

        # Host alias (default: key name)
        read -l -P "Host alias [$name]: " host_alias
        if test -z "$host_alias"
            set host_alias $name
        end

        # Hostname
        read -l -P 'Hostname: ' hostname
        if test -z "$hostname"
            echo "❌ Hostname required for config entry"
            return 1
        end

        # User (default: current user)
        read -l -P "User [$USER]: " ssh_user
        if test -z "$ssh_user"
            set ssh_user $USER
        end

        # Create SSH config if missing
        set config_file "$HOME/.ssh/config"
        if not test -f "$config_file"
            touch "$config_file"
            chmod 600 "$config_file"
        end

        # Append new entry
        echo "
Host $host_alias
    Hostname $hostname
    User $ssh_user
    IdentityFile $key_path
    IdentitiesOnly yes" >> "$config_file"

        echo
        echo "✅ SSH config updated!"
        echo "📝 Entry added: Host $host_alias"
        echo
        echo "🚀 Connect with:"
        echo "   ssh $host_alias"
    else
        echo
        echo "📤 Copy public key:"
        echo "   cat $key_path.pub"
    end

    echo
end
