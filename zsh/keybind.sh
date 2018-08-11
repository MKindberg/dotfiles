setxkbmap -option caps:escape

bindkey '^[[Z' reverse-menu-complete
bindkey "^[%" vi-match-bracket
bindkey -s "^Z" "%\n"
