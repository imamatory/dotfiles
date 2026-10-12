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

## Troubleshooting

- **nvim crashes immediately on macOS startup (SIGKILL, no error shown):** check `~/Library/Logs/DiagnosticReports/nvim-*.ips`. A `CODESIGNING "Invalid Page"` kill in `lua_pcall → dlopen` means avante.nvim's cargo-built sidecars (`~/.local/share/nvim/lazy/avante.nvim/lua/avante_*.so`) fail signature validation after a rebuild. Fix — copy to a fresh inode, then ad-hoc re-sign:
  ```sh
  cd ~/.local/share/nvim/lazy/avante.nvim/lua
  cp avante_templates.so /tmp/x.so && mv /tmp/x.so avante_templates.so
  codesign --force --sign - avante_templates.so
  ```
  Use whichever `avante_*.so` the crash report fingered; applying it to all four is safe. Re-signing in place is NOT enough — the kernel keeps flagging the cached inode, so the file must be replaced first. Note `nvim --headless +qa` won't reproduce this (crash happens when a UI attaches).

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
