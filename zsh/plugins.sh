# zinit comes from git, not brew, so `zinit self-update` (mise run upgrade) works.
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
  print -P "%F{220}Installing zinit…%f"
  command mkdir -p "${ZINIT_HOME:h}" && command chmod g-rwX "${ZINIT_HOME:h}"
  command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

zi light-mode for \
  OMZ::lib/git.zsh \
  OMZ::plugins/git/git.plugin.zsh \
  OMZ::plugins/tmux/tmux.plugin.zsh \
  OMZ::plugins/docker-compose/docker-compose.plugin.zsh \
  OMZ::plugins/yarn/yarn.plugin.zsh \
  OMZ::plugins/vi-mode/vi-mode.plugin.zsh \
  OMZP::extract \
  OMZP::bgnotify \
  MichaelAquilina/zsh-you-should-use

# fzf-tab draws the completion menu with fzf, so zsh's own menu is off.
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:(cd|z):*' fzf-preview 'lsd -1 --color=always $realpath'

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Completions that need compdef/complete, so they must run after compinit.
_zsh_after_compinit() {
  # zoxide registers `z` only when compdef exists at its init, which is earlier
  (( $+functions[__zoxide_z_complete] )) && compdef __zoxide_z_complete z
  # aws ships no zsh completion, only the bash-style aws_completer
  if (( $+commands[aws_completer] )); then
    autoload -Uz bashcompinit && bashcompinit
    complete -C "$commands[aws_completer]" aws
  fi
}

# Turbo: loads right after the first prompt, in this order.
# - compinit runs once, here: every fpath entry must be added before it (zshrc).
# - fzf-tab needs compinit first and must load before the plugins that wrap
#   widgets (fast-syntax-highlighting, autosuggestions).
# - Bind autosuggest keys in atload: a bindkey to a widget that does not exist
#   yet makes fast-syntax-highlighting warn "unhandled ZLE widget".
zi wait lucid light-mode for \
  atinit"zicompinit; zicdreplay; _zsh_after_compinit" \
      Aloxaf/fzf-tab \
  zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start; bindkey '^[^ ' autosuggest-execute; bindkey '^ ' autosuggest-accept" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions
