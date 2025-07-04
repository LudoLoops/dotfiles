# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

### Git

```bash
pacman -S git
```

### Stow

```bash
pacman -S stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```bash
git clone git@github.com:neuroloops/dotfiles.git
cd dotfiles
```

## Init submodules

```bash
git submodule update --init --recursive
```

## Symlinks

Then use GNU stow to create symlinks

```bash
 stow .
```
