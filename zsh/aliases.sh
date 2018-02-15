# Bash aliases

alias ls='echo '' && ls -hF --color=tty'                 # classify files in colour
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
alias gb='git branch'
alias go='git checkout'
alias gl='git log'
alias ga='git add'
alias gaa='git add --all'
alias gd='git diff'
alias gg='git grep -n --break --heading'
alias gci='git commit'
alias grm='git-rm'
alias gmv='git-mv'
alias gti='git'

alias fn='find -name'

alias cim='vim'

alias -s c=vim
alias -s h=vim
alias -s cpp=vim
alias -s sh=vim
