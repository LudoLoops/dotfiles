# Multi-machine updates from TufTux

Run from TufTux (Arch Linux, Fish):

- `update --list` — local inventory (TufTux, Atlas, Nova, Anrisol)
- `update --host nova` — one machine
- `update` — all enabled machines in sequence
- `update --refresh` — discover new Tailscale peers (new peers are ignored by default)

`~/.config/fish/servers.json` is private local state, and overrides such as `ignore: true` or custom SSH destinations are preserved. Missing default hosts are added automatically.

## One-time passwordless setup

All subsequent SSH operations run with `BatchMode=yes`. An unknown host key must first be verified/accepted with a normal SSH login; SSH public-key authentication and any encrypted-key agent unlock must also be set up beforehand. The command fails rather than asking for a password.

Check the connections **before** running updates:

```sh
ssh -o BatchMode=yes atlas 'sudo -n nixos-rebuild --help >/dev/null'
ssh -o BatchMode=yes loops@nova 'sudo -n nixos-rebuild --help >/dev/null'
ssh -o BatchMode=yes atlas 'ssh -o BatchMode=yes anrisol true'
ssh -o BatchMode=yes atlas 'ssh -o BatchMode=yes anrisol "sudo -n /run/current-system/sw/bin/nixos-rebuild --help >/dev/null"'
```

Atlas has an explicit passwordless `nixos-rebuild` rule; Nova has passwordless `wheel` sudo. Anrisol is updated *through Atlas* using the existing SSH alias `anrisol`, which uses the SOPS-managed key and logs in as `loops`. Prefer `sudo -n nixos-rebuild` on Anrisol; a key-only `root@anrisol` login is only a compatibility fallback. The narrow `sudo` rule is declared in GitLab `lelabdev/infra/srv-anrisol/nix` MR !5. **It requires one privileged NixOS activation before passwordless updates can work**. No SSH private keys go in the repository.

If the fallback root login is also unavailable, a privileged Anrisol session must activate the sudo rule once. The script will report this explicitly rather than request a password. `nixos-rebuild` can apply arbitrary NixOS configuration and must be treated as root-equivalent even with a command-scoped sudo rule.

### Private GitLab access on Nova

Nova has no GitLab SSH private key. For `update --host nova`, the TufTux SSH
agent is forwarded **only for the duration of that SSH session**. No key is
copied to Nova. On TufTux, a GitLab-authorized SSH identity must already be
loaded in your agent:

```sh
ssh-add -l
ssh -A -o ControlMaster=no -o ControlPath=none loops@nova \
  'git -C ~/nixos-nova ls-remote --exit-code origin refs/heads/main'
```

The update script runs the same GitLab preflight without waiting for a password.
If it fails, configure the existing TufTux SSH agent/key; do not replace GitLab
access with unauthenticated HTTPS. Agent forwarding grants Nova temporary use
of the forwarded identities while the connection is alive, so use it only with
a trusted and secured server. A dedicated read-only GitLab deploy key on Nova
is an alternative if forwarding is undesirable, but publishing `flake.lock`
also requires GitLab write access.

### Pending Atlas flake.lock changes

If Atlas has **only** an unstaged `flake.lock` modification, `update`
preserves it in a named Git stash before fetching the newer `main`.
The Atlas updater then refreshes the flake inputs against current `main`,
runs the rebuild, and commits/pushes the new `flake.lock`. The prior
generated lock remains recoverable:

```sh
ssh atlas 'git -C ~/nixos-atlas stash list'
```

Other dirty files still block the update. Do not apply the old stashed
`flake.lock` over the new version without reviewing the differences.

### Arch package updates on TufTux

`paru` invokes root `pacman`, so a one-time local sudoers grant is needed for unattended package updates. Run these commands **once**, interactively, while logged in as your regular TufTux user:

```sh
printf '%s\n' "$USER ALL=(root) NOPASSWD: /usr/bin/pacman, /usr/bin/paccache" \
  | sudo tee /etc/sudoers.d/90-tuftux-updates >/dev/null
sudo chmod 0440 /etc/sudoers.d/90-tuftux-updates
sudo visudo -cf /etc/sudoers.d/90-tuftux-updates
sudo -n /usr/bin/pacman -Q pacman
```

**Security trade-off:** unrestricted `pacman` arguments effectively give the local account root-level powers (package install scripts execute as root). This is convenient but not a narrow privilege boundary. Do not grant this to additional users or copy the rule to servers.

The script only updates **user** Flatpaks without prompts; system Flatpaks may still require administrative authorization. Production servers are updated sequentially; updates can restart services, so check backups and maintenance windows first.

## Implementation

- TufTux: `paru` + cache cleanup + user Flatpaks
- Atlas: `~/nixos-atlas/tools/update-atlas.sh` (keeps Herdr tracking its latest stable release)
- Nova: temporary TufTux SSH agent forwarding for GitLab access, then `~/nixos-nova` pull, flake refresh, lock commit/push, `sudo -n nixos-rebuild`
- Anrisol: on Atlas, locate the NVMe NixOS checkout, pull/flake update, rsync over Tailscale, then run `sudo -n nixos-rebuild` via `loops` (fallback: legacy SSH root access)

On errors (uncommitted Git changes, missing credentials, unreachable host), the failing machine is reported. Other enabled hosts continue to run.
