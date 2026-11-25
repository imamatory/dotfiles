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
files/           — dotfiles symlinked into ~/ (zshrc, zshenv — bash-like options for non-interactive agent shells, tmux.conf, gitconfig, tigrc, alacritty.toml, gitui configs, xprofile, xmodemap)
zsh/             — scripts sourced by zshrc: aliases.sh, plugins.sh (Zinit), fzf.sh
nvim/            — Neovim (LazyVim) config, symlinked to ~/.config/nvim
  init.lua       — entry point, calls require('config.lazy')
  lua/
    config/      — lazy.lua (bootstrap + extras imports), options.lua, keymaps.lua, autocmds.lua (auto-loaded by LazyVim)
    plugins/     — plain spec lists, one file per concern, all auto-imported
```

## Neovim architecture

- **LazyVim distribution** on lazy.nvim (lockfile: `nvim/lazy-lock.json`).
- Extras: import them in `lua/config/lazy.lua` and keep `extras` in `nvim/lazyvim.json` empty (`:LazyExtras` writes there and silently pulls in plugins).
- Markdown: marksman + rumdl LSP (`plugins/markdown.lua`); rumdl is pinned per project via mise, so the server starts only where `.rumdl.toml` exists. The `lang.markdown` extra stays off (it brings render-markdown, markdown-preview, markdownlint-cli2); render-markdown is also disabled explicitly.
- Leader `<Space>`, localleader `\` (LazyVim defaults).
- Colorscheme: catppuccin frappe. Also vim-test + dispatch (`<leader>t`), nvim-spectre (`<leader>ssr`), Navigator window nav (`C-h/j/k/l`), vim-easy-align (`ga`), fugitive.
- Format on save is off (`vim.g.autoformat = false` in `options.lua`); format with `<leader>cf`.

## Troubleshooting

- **nvim crashes immediately on macOS startup (SIGKILL, no error shown):** check `~/Library/Logs/DiagnosticReports/nvim-*.ips`. A `CODESIGNING "Invalid Page"` kill in `lua_pcall → dlopen` means a plugin's locally built native library (`~/.local/share/nvim/lazy/<plugin>/**/*.so|*.dylib`, the one the crash report names) fails signature validation after a rebuild. Fix: copy it to a fresh inode, then ad-hoc re-sign:
  ```sh
  cp lib.so /tmp/x.so && mv /tmp/x.so lib.so
  codesign --force --sign - lib.so
  ```
  Re-signing in place is NOT enough — the kernel keeps flagging the cached inode, so the file must be replaced first. Note `nvim --headless +qa` won't reproduce this (crash happens when a UI attaches).

## Mise

- `mise.toml` is symlinked to `~/.config/mise/config.toml` by `make dotfiles`. `[tools]` holds interpreters (go, node, python, rust); `[bootstrap.packages]` holds every brew formula and cask (taps in `[bootstrap.brew.taps]`). Hooks (as in mokevnin/dotfiles): `pre-packages` installs brew if missing, `postinstall`/`post-tools` generate zsh completions via `misecompsync` (fpath set in `files/zshrc_common`). Symlinks, git clones (tpm, alacritty theme) and the login shell live in the same `mise.toml` (`[dotfiles]`, `[bootstrap.repos]`, `[bootstrap.user]`).
- `mise run upgrade` updates everything: mise tools, brew, zinit plugins (`zinit update --all`).
- Apply with `make mac` (`mise bootstrap --only packages,files,tools,macos-defaults,repos,dotfiles,user,task`, which also applies `[bootstrap.macos.*]` — replaces the old `mac-settings` target); preview with `--dry-run`, check with `mise bootstrap macos defaults status`; restart the Dock with `killall Dock`. Use canonical brew names (`kubernetes-cli`, `pkgconf`).

## CLI tools for agents

Installed via `[bootstrap.packages]`; prefer them over slower defaults: `rg` (search), `fd` (find files), `ast-grep`/`sg` (structural search and rewrites), `jq`/`yq` (JSON/YAML), `gh`/`glab` (GitHub/GitLab), `shellcheck`/`shfmt` (lint and format sh/bash scripts only, they do not support zsh; for zsh files like `files/zshrc_common` and `zsh/*.sh` use `zsh -n <file>` to check syntax), `hyperfine` (benchmarks, e.g. zsh startup).

## Agent skills

- `.claude/skills/` and `skills-lock.json` are the source of truth for skills (packages `mattpocock/skills`, `vercel-labs/skills`), not a working copy. Do not install, update or remove global skills yourself; the user does that by hand (see README).
- Add or update skills here with the `skills` CLI (`skills add <package> -a claude-code -y -s <name>`, `skills update -p`) so the lock stays consistent. Do not use `skills experimental_install` (it restores from GitHub into `.agents/skills`).
- Never copy these skills into other repos' tracked files.

## Git config

- Pager: `git-delta` with `navigate = true`, `light = false`.
- `pull.rebase = true`
- `init.defaultBranch = main`
- `merge.conflictstyle = diff3`
- User: Vadim Safonov / imamatory@gmail.com
- Hardcoded personal paths in zshrc: `/Users/im/yandex-cloud`, `/Users/im/.docker/completions`.
