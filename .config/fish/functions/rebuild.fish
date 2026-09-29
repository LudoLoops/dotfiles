function rebuild --description 'Pull Atlas configuration and rebuild NixOS'
    set -l repo "$HOME/nixos-atlas"

    if not test -f "$repo/flake.nix"
        echo "❌ NixOS flake not found at $repo"
        return 1
    end

    echo "📥 Pulling Atlas configuration..."
    command git -C "$repo" pull --ff-only
    or return 1

    echo " Rebuilding Atlas..."
    command sudo nixos-rebuild switch --flake "$repo#atlas"
end
