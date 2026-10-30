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
ssh -o BatchMode=yes anrisol 'sudo -n /run/current-system/sw/bin/nixos-rebuild --help >/dev/null'
```

Atlas has an explicit passwordless `nixos-rebuild` rule; Nova has passwordless `wheel` sudo. Anrisol is reached **directly from TufTux**, without an Atlas jump host. Anrisol requires an authorized SSH identity and a noninteractive `sudo -n nixos-rebuild` rule for the `loops` account. No private keys go in the repository.

The update script clones `lelabdev/infra/srv-anrisol/nix` into a temporary directory on TufTux, synchronizes its tracked contents directly to Anrisol, and runs a path-flake rebuild on Anrisol. It does not use an Atlas checkout or initiate SSH from Anrisol to Atlas. This workflow applies the repository's committed `flake.lock`; updating that lock is a separate Git operation.

### Private GitLab access on Nova

Nova uses its own GitLab SSH identity, configured declaratively by
`modules/gitlab-credentials.nix` in `lelabdev/infra/srv-nova/nix`.
The private key stays on Nova at
`/home/loops/.ssh/id_ed25519_gitlab_nova`; it must never be committed
to Git or copied from TufTux.

`update --host nova` connects to Nova without SSH agent forwarding.
Nova checks repository access with its own identity, then pulls and
updates its flake. The identity must have the necessary GitLab permissions
to read the private repository and push an updated `flake.lock`.

If the GitLab preflight fails, verify the Nova identity and GitLab permissions.
Do not enable agent forwarding or substitute unauthenticated HTTPS.

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
- Nova: its own GitLab SSH identity, then `~/nixos-nova` pull, flake refresh, lock commit/push, `sudo -n nixos-rebuild`
- Anrisol: clone GitLab on TufTux, rsync directly to Anrisol over SSH, and rebuild using the synchronized path flake; no Atlas dependency

On errors (uncommitted Git changes, missing credentials, unreachable host), the failing machine is reported. Other enabled hosts continue to run.
