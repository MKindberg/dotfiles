bindkey "^[" vi-cmd-mode
bindkey '^[[Z' reverse-menu-complete
bindkey "^[%" vi-match-bracket
bindkey -s "^Z" "%\n"

stty -ixon # Unbind current ctrl+s behavior
launch-in-split() { Launch command in new tmux split
  if [[ -n "$TMUX" ]]; then
    BUFFER="tmux split-window -h \"tmux select-pane -l; echo -e \\\"$BUFFER\n-----\n\\\"; $BUFFER; read\""
    zle accept-line
  fi
}
zle -N launch-in-split
bindkey "^s" launch-in-split
