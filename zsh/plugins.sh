source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

## Load a few important annexes, without Turbo
# (this is currently required for annexes)
zi light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zi light-mode for \
  zsh-users/zsh-autosuggestions \
  zdharma/fast-syntax-highlighting \
  OMZ::lib/git.zsh \
  OMZ::plugins/git/git.plugin.zsh \
  OMZ::plugins/tmux/tmux.plugin.zsh \
  OMZ::plugins/docker/docker.plugin.zsh \
  OMZ::plugins/docker-compose/docker-compose.plugin.zsh \
  OMZ::plugins/kubectl/kubectl.plugin.zsh \
  OMZ::plugins/yarn/yarn.plugin.zsh \
  OMZ::plugins/vi-mode/vi-mode.plugin.zsh \
  OMZP::extract \
  OMZP::bgnotify \
  MichaelAquilina/zsh-you-should-use \
  mattberther/zsh-pyenv

zi light ogham/exa
zi light sharkdp/bat
zi light sharkdp/fd
zi light BurntSushi/ripgrep

# zi ice depth=1;
# zi light romkatv/powerlevel10k

# Load starship theme
zinit ice as"command" from"gh-r" \
  atclone="
    ./starship init zsh > init.zsh
    ./starship completions zsh > _starship
  " \
  atpull="%atclone" src"init.zsh"
zinit light starship/starship
