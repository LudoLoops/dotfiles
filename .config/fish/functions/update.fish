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
            __update_nixos (command hostname -s) "" true
            return $status

        case '*'
            echo "❌ Unsupported OS: $os_id"
            return 1
    end

    echo "✅ System update complete"
end

function __update_remote --argument ssh_target display_name
    echo
    echo "━━━ $display_name ━━━"

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
    echo "Unsupported NixOS host: register it in the shared NixOS updater." >&2
    exit 1
    ;;
  *)
    echo "Unsupported OS: $ID" >&2
    exit 1
    ;;
esac'

    set -l encoded (command printf '%s' "$script" | command base64 -w0)
    command ssh -t "$ssh_target" "printf %s $encoded | base64 -d | bash"
end

function __update_nixos --argument-names machine ssh_target is_local
    # One deployment flow for the three NixOS machines.
    # Server deploy keys are read-only: only Atlas publishes flake.lock.
    set -l host (string lower -- "$machine")
    set -l repo
    set -l write_mode readonly

    switch "$host"
        case atlas
            set repo /home/loops/nixos-atlas
            set write_mode writable
        case nova
            set repo /home/loops/nixos-nova
        case anrisol
            # Preserve the older rsync-managed /root/nixos-anrisol checkout.
            set repo /root/nixos-anrisol-git
        case '*'
            echo "Unsupported NixOS machine: $machine" >&2
            return 1
    end

    echo
    echo "━━━ $host ━━━"

    set -l script 'set -euo pipefail
host="$1"
repo="$2"
write_mode="$3"
remote="git@gitlab.com:lelabdev/infra/nixos-${host}.git"

# Clone only when no Git checkout exists; never replace another directory.
if [ ! -d "$repo/.git" ]; then
    if [ -e "$repo" ]; then
        echo "Refusing to replace existing directory: $repo" >&2
        exit 1
    fi
    echo "Cloning $host configuration..."
    git clone --branch main --single-branch "$remote" "$repo"
fi

status="$(git -C "$repo" status --porcelain)"
if [ -n "$status" ]; then
    if [ "$host" = atlas ] && [ "$status" = " M flake.lock" ]; then
        echo "Resuming previous Atlas flake.lock update..."
    else
        echo "Repository has local changes: $repo" >&2
        git -C "$repo" status --short >&2
        echo "Commit or resolve them before updating." >&2
        exit 1
    fi
fi

# Check both private repositories before any deployment. The identity used
# here must also work for the private nixos-common flake input.
if [ "$write_mode" = readonly ]; then
    for url in "$remote" git@gitlab.com:lelabdev/infra/nixos-common.git; do
        if ! GIT_SSH_COMMAND="ssh -o BatchMode=yes -o StrictHostKeyChecking=yes" git ls-remote "$url" HEAD >/dev/null; then
            echo "GitLab SSH access failed on $host for $url" >&2
            echo "Check this users SSH identity, known_hosts, and GitLab deploy-key permissions." >&2
            exit 1
        fi
    done
fi

echo "Updating $host configuration from GitLab..."
git -C "$repo" switch main
git -C "$repo" pull --ff-only

if [ "$write_mode" = writable ]; then
    echo "Updating Nix flake inputs..."
    nix flake update --flake "$repo"
else
    echo "Using committed flake.lock (read-only GitLab access)..."
fi

# Check only the target host, not unrelated configurations (e.g. atlas-vm).
echo "Validating NixOS configuration for $host..."
nix eval --raw "$repo#nixosConfigurations.$host.config.system.build.toplevel.drvPath" >/dev/null

if [ "$write_mode" = writable ] && ! git -C "$repo" diff --quiet -- flake.lock; then
    echo "Publishing updated flake.lock..."
    git -C "$repo" add -- flake.lock
    git -C "$repo" commit -m "chore(flake): update inputs"
    git -C "$repo" push origin main
fi

echo "Activating NixOS on $host..."
if [ "$(id -u)" -eq 0 ]; then
    nixos-rebuild switch --flake "$repo#$host"
else
    sudo -n nixos-rebuild switch --flake "$repo#$host"
fi
echo "$host update complete"
'

    set -l encoded (command printf '%s' "$script" | command base64 -w0)
    if test "$is_local" = true
        if test "$host" = anrisol
            command printf '%s' "$script" | command sudo -H bash -s -- "$host" "$repo" "$write_mode"
        else
            command printf '%s' "$script" | command bash -s -- "$host" "$repo" "$write_mode"
        end
    else if test "$host" = anrisol
        # Anrisol needs root to read its GitLab deploy key and switch NixOS.
        command ssh -tt "$ssh_target" "printf %s $encoded | base64 -d | sudo -H bash -s -- '$host' '$repo' '$write_mode'"
    else
        command ssh -tt "$ssh_target" "printf %s $encoded | base64 -d | bash -s -- '$host' '$repo' '$write_mode'"
    end
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

    set -l name (string lower -- "$requested")
    if contains -- "$name" atlas nova anrisol
        if test "$is_local" = true
            __update_nixos "$name" "" true
        else
            if test -z "$ssh_target"
                echo "No SSH target configured for $requested" >&2
                return 1
            end
            __update_nixos "$name" "$ssh_target" false
        end
    else if test "$is_local" = true
        echo
        echo "━━━ $requested ━━━"
        __update_local
    else
        if test -z "$ssh_target"
            echo "No SSH target configured for $requested" >&2
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
