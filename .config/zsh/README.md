# Server Zsh aliases

Small, opt-in Zsh alias set adapted from the existing Fish configuration. This is
for remote Linux servers; Fish on TufTux remains unchanged.

## Included

- Directory shortcuts: `..`, `...`, `.3`, `.4`, `.5`
- File listing shortcuts with `eza` when installed and `ls` fallbacks
- General shortcuts (`mkdir`, `mv`, `df`, `free`, `copy`, `wget`, tar, IP)
- Existing Git shortcuts (`g`, `addup`, `addall`, `branch`, `clone`,
  `fetch`, `pull`, `push`)

No automatic package installs, default-shell changes, or changes to the Fish
configuration. The more complex Fish functions and machine-specific aliases are
deliberately excluded.

## Use on a server

If this repository is already available on the server, copy only the alias
file (no need to Stow the complete desktop configuration):

```sh
mkdir -p ~/.config/zsh
cp /path/to/dotfiles/.config/zsh/aliases.zsh ~/.config/zsh/aliases.zsh
```

Then add **once** to the server user's existing `~/.zshrc`:

```zsh
[[ -r "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"
```

Open a new interactive Zsh session, or run `source ~/.zshrc` from Zsh.

If this repository is already Stowed on that account, the alias file may
already exist at `~/.config/zsh/aliases.zsh`; only the `~/.zshrc` source line
is needed. Do not Stow the entire TufTux desktop configuration just for these
aliases on a server.

## Verify

```sh
zsh -n ~/.config/zsh/aliases.zsh
zsh -f -i -c 'source ~/.config/zsh/aliases.zsh; alias ll; alias g'
```

The fallback listing commands work without `eza`. Optional aliases are
enabled only when their corresponding executable is available.

Note: Fish abbreviations become Zsh aliases here: unlike Fish abbreviations,
they are expanded at execution, not inserted into the editable command line.
