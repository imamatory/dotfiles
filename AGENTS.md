# AGENTS.md — dotfiles

## What this repo is

Mise-managed personal dotfiles (Ansible was removed). A single root `mise.toml` holds everything: packages, tools, macOS defaults, `[dotfiles]` symlinks, `[bootstrap.repos]` and the login shell. No CI/CD, no tests.

## Entry points & commands

Primary entry: `Makefile`. Common targets:

| Command             | What it does                                             |
| ------------------- | -------------------------------------------------------- |
| `make mac`          | `make dotfiles`, then `mise bootstrap`: brew packages, tools, macOS defaults, repos (tpm, alacritty theme), dotfiles, login shell |
| `make mac-install`  | xcode → homebrew → mise, then `make mac` |
| `make dotfiles`     | Links `mise.toml` as the global mise config, then `mise dot apply` |


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
- Extras imported in `lua/config/lazy.lua`: snacks_picker, dap.core, lang extras (typescript, go, python, elixir, rust, json, yaml, docker, markdown), formatting.prettier.
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

## Mise

- `mise.toml` is symlinked to `~/.config/mise/config.toml` by `make dotfiles`. `[tools]` holds interpreters (go, node, python, rust); `[bootstrap.packages]` holds every brew formula and cask (taps in `[bootstrap.brew.taps]`). Hooks (as in mokevnin/dotfiles): `pre-packages` installs brew if missing, `postinstall`/`post-tools` generate zsh completions via `misecompsync` (fpath set in `files/zshrc_common`). Symlinks, git clones (tpm, alacritty theme) and the login shell live in the same `mise.toml` (`[dotfiles]`, `[bootstrap.repos]`, `[bootstrap.user]`).
- `mise run upgrade` updates everything: mise tools, brew, zinit plugins (`zinit update --all`).
- Apply with `make mac` (`mise bootstrap --only packages,files,tools,macos-defaults,repos,dotfiles,user,task`, which also applies `[bootstrap.macos.*]` — replaces the old `mac-settings` target); preview with `--dry-run`, check with `mise bootstrap macos defaults status`; restart the Dock with `killall Dock`. Use canonical brew names (`kubernetes-cli`, `pkgconf`).

## Git config

- Pager: `git-delta` with `navigate = true`, `light = false`.
- `pull.rebase = true`
- `init.defaultBranch = main`
- `merge.conflictstyle = diff3`
- User: Vadim Safonov / imamatory@gmail.com
- Hardcoded personal paths in zshrc: `/Users/im/yandex-cloud`, `/Users/im/.docker/completions`.
