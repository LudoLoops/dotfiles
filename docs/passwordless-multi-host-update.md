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
ssh -o BatchMode=yes atlas 'ssh -o BatchMode=yes -o IdentitiesOnly=yes -i "$HOME/.ssh/id_ed25519_anrisol-atlas" root@anrisol true'
```

Atlas has an explicit passwordless `nixos-rebuild` rule; Nova has passwordless `wheel` sudo. Anrisol is updated *through Atlas* using the already configured dedicated root key and does not require adding passwordless sudo on the VPS. No SSH private keys go in the repository.

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
- Nova: `~/nixos-nova` pull, flake refresh, lock commit/push, `sudo -n nixos-rebuild`
- Anrisol: on Atlas, `~/1Dev-nvme/projects/nixos-anrisol` pull/flake update, rsync over Tailscale, and root `nixos-rebuild` on Anrisol

On errors (uncommitted Git changes, missing credentials, unreachable host), the failing machine is reported. Other enabled hosts continue to run.
