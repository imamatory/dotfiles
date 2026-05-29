# AGENTS.md — dotfiles

## What this repo is

Ansible-managed personal dotfiles. The whole repo is the source of truth — every `*.yml` playbook is run against `localhost` (inventory is single-entry). There is no CI/CD, no tests, and no Dockerfile (despite `docker-*` Makefile targets referring to `imamatory/dotfiles`).

## Entry points & commands

Primary entry: `Makefile`. Common targets:

| Command | What it does |
|---------|-------------|
| `make setup-arch` | Full Arch install (prep → gnome-settings → pacman → AUR) |
| `make mac` | macOS: installs Homebrew packages (see `mac.yml`) |
| `make mac-install` | xcode → homebrew → ansible, then runs `mac` |
| `make ubuntu` | Ubuntu apt + cargo installs |
| `make dotfiles` | Symlinks config files from `files/` → `~/` |
| `make nvim-install` | Symlinks `nvim/` → `~/.config/nvim` |
| `make common` | fzf, TPM, chsh to zsh (runs on all OS) |

All playbooks use `-i inventory` (localhost) and `-vv` verbosity. `-K` prompts for sudo.

## Directory layout

```
files/           — dotfiles symlinked into ~/ (zshrc, tmux.conf, gitconfig, tigrc, alacritty.toml, gitui configs, vimrc, xprofile, xmodemap)
zsh/             — scripts sourced by zshrc: aliases.sh, plugins.sh (Zinit), fzf.sh
nvim/            — Neovim config, symlinked to ~/.config/nvim
  init.vim       — entry point, calls require('init')
  lua/
    init.lua     — requires globals, config.lazy, mappings
    config/lazy.lua — lazy.nvim bootstrap
    plugins/      — each file exports get_plugins() returning a list of plugin specs
      init.lua    — collects all plugin modules (core, lsp, dev, nvim-cmp, ai)
```

## Neovim architecture

- Plugin manager: **lazy.nvim** (lockfile: `nvim/lazy-lock.json`).
- Plugin specs are modular: each file in `lua/plugins/*.lua` exports `get_plugins()`.
- `plugins/init.lua` iterates over modules and aggregates specs.
- Highlights: catppuccin (frappe), fzf-lua (not telescope), avante.nvim (AI), nvim-spectre (search/replace), vim-test with dispatch.

## OS-specific notes

- **Arch** (`arch.yml`): pacman packages + Yay from AUR for google-chrome, debtap.
- **macOS** (`mac.yml`): Homebrew packages only — no dotfiles here, run `make dotfiles` separately.
- **Ubuntu** (`ubuntu.yml`): apt, cargo, manual .deb downloads for ripgrep/bat/kitty-terminfo, oh-my-zsh, spacemacs.

## Git config

- Pager: `git-delta` with `navigate = true`, `light = false`.
- `pull.rebase = true`
- `init.defaultBranch = main`
- `merge.conflictstyle = diff3`
- User: Vadim Safonov / imamatory@gmail.com
- Hardcoded personal paths in zshrc: `/Users/im/yandex-cloud`, `/Users/im/.docker/completions`.
