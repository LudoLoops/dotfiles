# Multi-machine system updater
# - update                    Update every enabled host in servers.json
# - update --host <name>      Update one host
# - update --refresh          Refresh inventory from Tailscale
# - update --list             Show inventory
# - update --local            Update only the current machine

function __update_local
    set -l os_id (string replace -r '^ID="?([^"]+)"?.*$' '$1' (grep '^ID=' /etc/os-release 2>/dev/null))

    switch "$os_id"
        case arch cachyos manjaro
            echo "📦 Updating Arch packages..."
            command paru -Syu --noconfirm --sudoflags "-n" || return 1

            if type -q paccache
                echo "🧹 Cleaning package cache..."
                command sudo paccache -rk1 || echo "⚠️  Package cache cleanup failed"
            end

            if type -q flatpak
                echo "📦 Updating Flatpaks..."
                command flatpak update -y || echo "⚠️  Flatpak update failed"
            end

        case debian ubuntu
            echo "📦 Updating Debian packages..."
            command sudo -n apt update || return 1
            command apt list --upgradable 2>/dev/null
            command sudo -n apt upgrade -y || return 1
            command sudo -n apt autoremove -y || return 1

        case nixos
            set -l repo "$HOME/nixos-atlas"
            if not test -f "$repo/flake.nix"
                echo "❌ NixOS flake not found at $repo"
                return 1
            end

            if test -n (command git -C "$repo" status --porcelain)
                echo "❌ Atlas repository is dirty: $repo"
                echo "   Commit, stash, or discard local changes before running update."
                return 1
            end

            echo "📦 Updating Atlas from its configuration repository..."
            command git -C "$repo" switch main || return 1
            command git -C "$repo" pull --ff-only || return 1

            echo "♻️  Updating Nix flake inputs..."
            command nix flake update --flake "$repo" || return 1

            if not command git -C "$repo" diff --quiet -- flake.lock
                echo "📝 Publishing updated flake.lock to GitLab..."
                command git -C "$repo" add flake.lock || return 1
                command git -C "$repo" commit -m "chore(flake): update inputs" || return 1
                command git -C "$repo" push origin main || return 1
            else
                echo "✅ Nix flake inputs already up to date"
            end

            command sudo nixos-rebuild switch --flake "$repo#atlas" || return 1

        case '*'
            echo "❌ Unsupported OS: $os_id"
            return 1
    end

    echo "✅ System update complete"
end

function __update_remote --argument ssh_target display_name
    echo
    echo "━━━ $display_name ($ssh_target) ━━━"

    set -l script 'set -e
. /etc/os-release

case "$ID" in
  arch|cachyos|manjaro)
    paru -Syu --noconfirm --sudoflags "-n"
    if command -v paccache >/dev/null 2>&1; then
      sudo paccache -rk1 || true
    fi
    if command -v flatpak >/dev/null 2>&1; then
      flatpak update -y || true
    fi
    ;;
  debian|ubuntu)
    sudo -n apt update
    apt list --upgradable 2>/dev/null
    sudo -n apt upgrade -y
    sudo -n apt autoremove -y
    ;;
  nixos)
    repo="$HOME/nixos-atlas"
    test -f "$repo/flake.nix" || { echo "NixOS flake not found at $repo" >&2; exit 1; }

    if [ -n "$(git -C "$repo" status --porcelain)" ]; then
      echo "Atlas repository is dirty: $repo" >&2
      echo "Commit, stash, or discard local changes before running update." >&2
      exit 1
    fi

    git -C "$repo" switch main
    git -C "$repo" pull --ff-only

    echo "Updating Nix flake inputs..."
    nix flake update --flake "$repo"

    if ! git -C "$repo" diff --quiet -- flake.lock; then
      echo "Publishing updated flake.lock to GitLab..."
      git -C "$repo" add flake.lock
      git -C "$repo" commit -m "chore(flake): update inputs"
      git -C "$repo" push origin main
    else
      echo "Nix flake inputs already up to date"
    fi

    sudo nixos-rebuild switch --flake "$repo#atlas"
    ;;
  *)
    echo "Unsupported OS: $ID" >&2
    exit 1
    ;;
esac'

    set -l encoded (command printf '%s' "$script" | command base64 -w0)
    command ssh -t "$ssh_target" "printf %s $encoded | base64 -d | bash"
end

function __update_inventory_path
    echo "$HOME/.config/fish/servers.json"
end

function __update_inventory_default_path
    echo "$HOME/.config/fish/servers.default.json"
end

function __update_ensure_inventory
    set -l inventory (__update_inventory_path)

    if test -f "$inventory"
        return
    end

    set -l default_inventory (__update_inventory_default_path)
    if test -f "$default_inventory"
        command cp "$default_inventory" "$inventory"
    else
        echo '{"hosts":[]}' >"$inventory"
    end
end

function __update_list
    set -l inventory (__update_inventory_path)
    __update_ensure_inventory


    command jq -r '.hosts[] | "\(.name)\t\(if .local then "local" else (.ssh // "-") end)\t\(if .ignore then "ignored" else "enabled" end)"' "$inventory"         | command column -t -s (printf '\t')
end

function __update_refresh
    set -l inventory (__update_inventory_path)
    __update_ensure_inventory

    if not type -q tailscale
        echo "❌ tailscale is not installed"
        return 1
    end

    if not type -q jq
        echo "❌ jq is required"
        return 1
    end

    set -l status_file (mktemp)
    set -l merged_file (mktemp)

    command tailscale status --json >"$status_file" || begin
        rm -f "$status_file" "$merged_file"
        return 1
    end

    command jq -s '
      def clean_dns: rtrimstr(".");
      .[0] as $old
      | .[1] as $ts
      | (
          [{
            name: ($ts.Self.HostName // ($ts.Self.DNSName | clean_dns)),
            ssh: null,
            local: true,
            ignore: false
          }]
          +
          [
            $ts.Peer[]?
            | {
                name: (.HostName // (.DNSName | clean_dns)),
                ssh: ((.DNSName // .HostName) | clean_dns),
                local: false,
                ignore: true
              }
          ]
        ) as $discovered
      | (
          $discovered
          | map(
              . as $new
              | (first($old.hosts[]? | select((.name | ascii_downcase) == ($new.name | ascii_downcase))) // null) as $existing
              | if $existing == null then
                  $new
                else
                  $new
                  + {
                      ssh: (if $existing.ssh == null then $new.ssh else $existing.ssh end),
                      ignore: $existing.ignore
                    }
                end
            )
        ) as $merged
      | ($merged | map(.name | ascii_downcase)) as $seen
      | {
          hosts:
            (
              $merged
              + [
                  $old.hosts[]?
                  | select((.name | ascii_downcase) as $name | ($seen | index($name) | not))
                ]
              | sort_by(.name)
            )
        }
    ' "$inventory" "$status_file" >"$merged_file" || begin
        rm -f "$status_file" "$merged_file"
        return 1
    end

    command mv "$merged_file" "$inventory"
    command rm -f "$status_file"

    echo "✅ Inventory refreshed from Tailscale"
    echo "   New machines are ignored by default."
    __update_list
end

function __update_host --argument requested
    set -l inventory (__update_inventory_path)
    __update_ensure_inventory

    if not type -q jq
        echo "❌ jq is required"
        return 1
    end

    set -l entry (command jq -c --arg name "$requested" '.hosts[] | select((.name | ascii_downcase) == ($name | ascii_downcase))' "$inventory")
    if test -z "$entry"
        echo "❌ Unknown host: $requested"
        return 1
    end

    set -l is_local (echo "$entry" | command jq -r '.local // false')
    set -l ssh_target (echo "$entry" | command jq -r '.ssh // empty')

    if test "$is_local" = true
        echo
        echo "━━━ $requested (local) ━━━"
        __update_local
    else
        if test -z "$ssh_target"
            echo "❌ No SSH target configured for $requested"
            return 1
        end
        __update_remote "$ssh_target" "$requested"
    end
end

function update
    set -l inventory (__update_inventory_path)
    __update_ensure_inventory
    set -l action ""

    if test (count $argv) -gt 0
        set action "$argv[1]"
    end

    switch "$action"
        case --help -h
            echo "Usage:"
            echo "  update                 Update every enabled host"
            echo "  update --host <name>   Update one host"
            echo "  update --refresh       Refresh hosts from Tailscale"
            echo "  update --list          Show inventory"
            echo "  update --local         Update only this machine"
            return

        case --refresh
            __update_refresh
            return $status

        case --list
            __update_list
            return $status

        case --local
            __update_local
            return $status

        case --host
            if test (count $argv) -lt 2
                echo "❌ Usage: update --host <name>"
                return 2
            end
            __update_host "$argv[2]"
            return $status

        case ''
            # Default: update every enabled machine.
        case '*'
            echo "❌ Unknown option: $argv[1]"
            echo "   Run: update --help"
            return 2
    end

    if not type -q jq
        echo "❌ jq is required"
        return 1
    end

    set -l hosts (command jq -r '.hosts[] | select(.ignore != true) | .name' "$inventory")
    if test (count $hosts) -eq 0
        echo "No enabled hosts in $inventory"
        return
    end

    set -l failed
    for host in $hosts
        __update_host "$host"
        or set -a failed "$host"
    end

    if test (count $failed) -gt 0
        echo
        echo "❌ Failed: "(string join ', ' $failed)
        return 1
    end

    echo
    echo "✅ All enabled machines updated"
end
