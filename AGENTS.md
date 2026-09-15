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
files/           — dotfiles symlinked into ~/ (zshrc, tmux.conf, gitconfig, tigrc, alacritty.toml, gitui configs, xprofile, xmodemap)
zsh/             — scripts sourced by zshrc: aliases.sh, plugins.sh (Zinit), fzf.sh
nvim/            — Neovim (LazyVim) config, symlinked to ~/.config/nvim
  init.lua       — entry point, calls require('config.lazy')
  lua/
    config/      — lazy.lua (bootstrap + extras imports), options.lua, keymaps.lua, autocmds.lua (auto-loaded by LazyVim)
    plugins/     — plain spec lists: colors, ai (avante), core (treesitter), editor, test
```

## Neovim architecture

- **LazyVim distribution** on lazy.nvim (lockfile: `nvim/lazy-lock.json`). Lives on the `lazyvim` branch; master keeps the old hand-rolled config.
- Extras imported in `lua/config/lazy.lua`: snacks_picker, dap.core, lang extras (typescript, go, python, ruby, elixir, rust, json, yaml, docker, markdown), formatting.prettier.
- Leader `<Space>`, localleader `\` (LazyVim defaults).
- Colorscheme: catppuccin frappe. AI: avante.nvim (Anthropic). Also vim-test + dispatch (`<leader>t`), nvim-spectre (`<leader>ssr`), Navigator window nav (`C-h/j/k/l`), vim-easy-align (`ga`), fugitive.
- xcode↔branch flip: `~/.config/nvim` symlink points at `~/dotfiles/nvim`, so `git switch master`/`lazyvim` swaps configs in place. Old nvim data dir backed up at `~/.local/share/nvim.bak-old-config`.

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
