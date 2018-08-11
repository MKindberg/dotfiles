setxkbmap -option caps:escape

bindkey '^[[Z' reverse-menu-complete
keybind "^[%" vi-match-bracket
bindkey -s "^Z" "%\n"
