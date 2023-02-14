[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fzf_opts=(
  '--border'
  '--height 80%'
  '--reverse'
  '--multi'
  '--bind "ctrl-a:select-all"'
  '--bind "ctrl-y:execute-silent(echo {+} | pbcopy)"'
  '--bind "ctrl-e:execute(echo {+} | xargs -o nvim)"'
  '--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284'
  '--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf'
  '--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284'
)
export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
export FZF_DEFAULT_OPTS=$fzf_opts

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# interactive cd
unalias g 2> /dev/null
g() {
  if [ $# -eq 0 ] ; then
    path_to_cd=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf )
    [[ -z "$path_to_cd" ]] && return || cd "$path_to_cd"
  else
    cd $@
  fi
}

f() {
fzf --border --height 80% --reverse --multi --bind "ctrl-y:execute-silent(echo {+} | xargs -o pbcopy)" --bind "enter:execute(echo {+} | xargs -o nvim)" --preview "([[ -f {} ]] && (bat --style=changes,numbers --color=always {} || cat {})) || ([[ -d {} ]] && (exa --icons --tree --level=2 {} | less)) || echo {} 2> /dev/null | head -200"
}

bindkey -s "^F" 'f^M'
bindkey -s "^g" 'g^M'
