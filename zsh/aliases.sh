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
alias gst='git status --untracked-files=no'
alias gb='git branch'
#alias go='git checkout'
alias gl='git log'
#alias ga='git add'
alias gaa='git add --all'
#alias gd='git diff'
alias gg='git grep -n --break --heading'
alias gci='git commit'
alias grm='git-rm'
alias gmv='git-mv'
alias gti='git'
alias gco='git commit'
alias gcom='git commit -m'
alias gap='git add -p'

alias fn='find -name'

alias cim='vim'

alias -s c=vim
alias -s h=vim
alias -s cpp=vim
alias -s html=firefox

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
