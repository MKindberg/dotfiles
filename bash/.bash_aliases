# Bash aliases

alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..

alias df='df -h'
alias du='du -h'

alias cd..='cd ..'

alias grep='grep --color'                     # show differences in colour

# git related
alias gs='git status'
alias gl='git log'
alias ga='git add'
alias gd='git diff'
