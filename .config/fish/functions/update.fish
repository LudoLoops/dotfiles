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
                command sudo -n paccache -rk1 || echo "⚠️  Package cache cleanup failed"
            end

            if type -q flatpak
                echo "📦 Updating Flatpaks..."
                command flatpak update --user -y || echo "⚠️  User Flatpak update failed"
            end

        case debian ubuntu
            echo "📦 Updating Debian packages..."
            command sudo -n apt update || return 1
            command apt list --upgradable 2>/dev/null
            command sudo -n apt upgrade -y || return 1
            command sudo -n apt autoremove -y || return 1

        case nixos
            set -l repo "$HOME/1Dev-nvme/projects/infra-hub/nixos-atlas"
            if not test -f "$repo/flake.nix"
                set repo "$HOME/nixos-atlas"
            end
            if not test -f "$repo/flake.nix"
                echo "❌ Atlas flake not found at $repo"
                return 1
            end

            set -l dirty (command git -C "$repo" status --porcelain)
            if test (count $dirty) -gt 0
                if test (count $dirty) -eq 1; and test "$dirty[1]" = ' M flake.lock'
                    # The upstream lockfile may have changed. Save the generated
                    # local copy, pull main, and let the updater regenerate it.
                    echo "📝 Atlas: saving pending flake.lock in a Git stash before pull..."
                    command git -C "$repo" stash push -m "update: pending flake.lock before pull" -- flake.lock; or return 1
                else
                    echo "❌ Atlas repository has local changes: $repo"
                    command git -C "$repo" status --short
                    echo "   Changes preserved. Review them before updating."
                    return 1
                end
            end

            command git -C "$repo" switch main || return 1
            command git -C "$repo" pull --ff-only || return 1

            if not test -f "$repo/tools/update-atlas.sh"
                echo "❌ Atlas updater not found at $repo/tools/update-atlas.sh"
                return 1
            end

            # Keep Atlas' latest-Herdr update behavior.
            command bash "$repo/tools/update-atlas.sh" || return 1

        case '*'
            echo "❌ Unsupported OS: $os_id"
            return 1
    end

    echo "✅ System update complete"
end

function __update_remote --argument-names ssh_target display_name
    echo
    set_color --bold cyan
    echo "━━━ "(string upper -- "$display_name")" ━━━━━━━━━━━━━━━━━━━━━"
    set_color normal

    if not string match -qr '^[A-Za-z0-9][A-Za-z0-9_-]*$' -- "$display_name"
        echo "❌ Invalid host name: $display_name"
        return 1
    end

    set -l script 'set -euo pipefail
export GIT_TERMINAL_PROMPT=0
export GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=10"
host="$1"
. /etc/os-release

case "$ID" in
  arch|cachyos|manjaro)
    paru -Syu --noconfirm --sudoflags "-n"
    if command -v paccache >/dev/null 2>&1; then
      sudo -n paccache -rk1 || echo "Package cache cleanup skipped"
    fi
    if command -v flatpak >/dev/null 2>&1; then
      flatpak update --user -y || echo "User Flatpak update skipped"
    fi
    ;;
  debian|ubuntu)
    sudo -n apt update
    apt list --upgradable 2>/dev/null
    sudo -n apt upgrade -y
    sudo -n apt autoremove -y
    ;;
  nixos)
    case "$host" in
      atlas|nova)
        repo="$HOME/1Dev-nvme/projects/infra-hub/nixos-$host"
        if [ ! -f "$repo/flake.nix" ]; then
          repo="$HOME/nixos-$host"
        fi
        ;;
      *) echo "No NixOS deployment defined for $host" >&2; exit 1 ;;
    esac
    test -f "$repo/flake.nix" || { echo "NixOS flake not found at $repo" >&2; exit 1; }

    dirty="$(git -C "$repo" status --porcelain)"
    if [ -n "$dirty" ]; then
      if [ "$host" = atlas ] && [ "$dirty" = " M flake.lock" ]; then
        echo "Atlas: saving pending flake.lock in Git stash before pulling main..."
        git -C "$repo" stash push -m "update: pending flake.lock before pull" -- flake.lock
        echo "Atlas: saved original lockfile (git stash list shows backup)."
      elif [ "$host" = nova ] && [ "$dirty" = "?? secrets/" ]; then
        echo "Nova: preserving untracked secrets/; these files will not be committed."
      else
        echo "Repository has local changes: $repo" >&2
        git -C "$repo" status --short >&2
        echo "Changes preserved. Review them before updating." >&2
        exit 1
      fi
    fi

    git -C "$repo" switch main

    if [ "$host" = nova ]; then
      echo "Nova: checking GitLab access with its own SSH identity..."
      if ! git -C "$repo" ls-remote --exit-code origin refs/heads/main >/dev/null; then
        echo "Nova cannot read its private GitLab repository." >&2
        echo "Check the GitLab SSH identity configured on Nova and its repository permissions." >&2
        exit 1
      fi
    fi

    git -C "$repo" pull --ff-only

    if [ "$host" = atlas ]; then
      test -f "$repo/tools/update-atlas.sh" || {
        echo "Atlas updater not found: $repo/tools/update-atlas.sh" >&2
        exit 1
      }
      bash "$repo/tools/update-atlas.sh"
    else
      nix flake update --flake "$repo"
      if ! git -C "$repo" diff --quiet -- flake.lock; then
        git -C "$repo" add flake.lock
        git -C "$repo" commit -m "chore(flake): update inputs"
        git -C "$repo" push origin main
      fi
      sudo -n nixos-rebuild switch --flake "$repo#$host"
    fi
    ;;
  *)
    echo "Unsupported OS: $ID" >&2
    exit 1
    ;;
esac'

    set -l encoded (command printf '%s' "$script" | command base64 -w0)
    set -l ssh_flags -T -o BatchMode=yes -o NumberOfPasswordPrompts=0 -o ConnectTimeout=10

    command ssh $ssh_flags "$ssh_target" "printf %s $encoded | base64 -d | bash -s -- '$display_name'"
end

function __update_via_atlas --argument-names host
    # Atlas owns the encrypted deploy tokens. No GitLab identity on TufTux.
    set -l ssh_flags -T -o BatchMode=yes -o NumberOfPasswordPrompts=0 -o ConnectTimeout=10 -o StrictHostKeyChecking=yes
    set -l atlas_command 'repo="$HOME/1Dev-nvme/projects/infra-hub/nixos-atlas"; if [ ! -f "$repo/tools/update-servers.sh" ]; then repo="$HOME/nixos-atlas"; fi; ATLAS_UPDATE_COLOR=1 bash "$repo/tools/update-servers.sh"'
    command ssh $ssh_flags atlas "$atlas_command $host"
end

function __update_inventory_path
    echo "$HOME/.config/fish/servers.json"
end

function __update_inventory_default_path
    echo "$HOME/.config/fish/servers.default.json"
end

function __update_ensure_inventory
    set -l inventory (__update_inventory_path)
    set -l defaults (__update_inventory_default_path)

    if not test -f "$inventory"
        if test -f "$defaults"
            command cp "$defaults" "$inventory"
        else
            echo '{"hosts":[]}' >"$inventory"
        end
        return
    end

    # Add new machines to existing inventories without overriding user choices.
    if not test -f "$defaults"
        return
    end
    if not type -q jq
        echo "❌ jq is required to update the host inventory"
        return 1
    end

    set -l merged (mktemp); or return 1
    command jq -s '
      .[0] as $current
      | .[1] as $defaults
      | ($current.hosts // []) as $known
      | {
          hosts: (
            $known + [
              $defaults.hosts[]?
              | select(.name as $name | ($known | any((.name | ascii_downcase) == ($name | ascii_downcase)) | not))
            ]
            | sort_by(.name)
          )
        }
    ' "$inventory" "$defaults" >"$merged"
    or begin
        command rm -f "$merged"
        return 1
    end

    if command cmp -s "$inventory" "$merged"
        command rm -f "$merged"
    else
        command mv "$merged" "$inventory"
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
        set_color --bold cyan
        echo "━━━ "(string upper -- "$requested")" ━━━━━━━━━━━━━━━━━━━━━"
        set_color normal
        __update_local
    else
        if test -z "$ssh_target"
            echo "❌ No SSH target configured for $requested"
            return 1
        end
        switch (string lower -- "$requested")
            case anrisol nova
                __update_via_atlas (string lower -- "$requested")
            case '*'
                __update_remote "$ssh_target" "$requested"
        end
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

    # Keep the local workstation distinct, then group the NixOS servers.
    # Other inventory hosts are still updated after the known machines.
    set -l ordered
    for preferred in TufTux atlas nova anrisol
        for host in $hosts
            if test (string lower -- "$host") = (string lower -- "$preferred")
                set -a ordered "$host"
            end
        end
    end
    for host in $hosts
        if not contains -- "$host" $ordered
            set -a ordered "$host"
        end
    end

    set -l failed
    set -l succeeded
    set -l server_heading_shown false
    for host in $ordered
        if contains -- (string lower -- "$host") atlas nova anrisol
            if test "$server_heading_shown" = false
                echo
                set_color --bold cyan
                echo "━━━ NIXOS SERVERS ━━━━━━━━━━━━━━━━━"
                set_color normal
                set server_heading_shown true
            end
        end
        if __update_host "$host"
            set -a succeeded "$host"
        else
            set -a failed "$host"
        end
    end

    echo
    set_color --bold cyan
    echo "━━━ UPDATE SUMMARY ━━━━━━━━━━━━━━━━"
    set_color normal
    for host in $ordered
        if contains -- "$host" $succeeded
            printf '  ✓ %-12s SUCCESS\n' "$host"
        else
            printf '  ✗ %-12s FAILED\n' "$host"
        end
    end
    if test (count $failed) -gt 0
        echo "  Failed: "(string join ', ' $failed)
        return 1
    end

    echo "  All enabled machines updated"
end
