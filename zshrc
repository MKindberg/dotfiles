#!/bin/zsh

source ~/dotfiles/shrc

autoload -Uz compinit
if [[ -n ~/.zcompdump(#qNmh-24) ]]; then
  compinit -C
else
  compinit
fi
# autoload -Uz zmv  # More powerful version of mv
# Plugins {{{

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:*' stagedstr '%F{yellow}+%f'
zstyle ':vcs_info:git:*' formats       '%F{green}(%b)%f%c%u'
zstyle ':vcs_info:git:*' actionformats '%F{green}(%b|%a)%f%c%u'   # %a = rebase/merge/etc in progress

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/lib/git-core/git-sh-prompt
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# }}}

# Options {{{
setopt hist_ignore_all_dups

setopt autocd
setopt correct_all
setopt AUTO_LIST
setopt AUTO_MENU
setopt LIST_AMBIGUOUS
#
#setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY

# }}}

# Variables {{{
# }}}

# Functions {{{
# }}}

# Aliases {{{
alias -s c=vim
alias -s h=vim
alias -s cpp=vim
alias -s html=firefox

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

alias reload='source ~/.zshrc'
alias zshrc='nvim ~/.zshrc'
# }}}

# Prompt {{{
setopt PROMPT_SUBST

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=1

function preexec() {
  retrace --add "$1"

  timer=${timer:-$SECONDS}
}

function precmd() {
  vcs_info
  if [ $timer ]; then
    if [[ $(($SECONDS - $timer)) -gt 5 ]]; then
      timer_show=$(($SECONDS - $timer))s
    else
      timer_show=""
    fi
    unset timer
  fi
  dirs="$(dirs -v | tr '\t' ' ' | tr '\n' '\t' | cut -f 2,3,4,5)"
 }
local ret_status="%(?:%{%F{green}:%F{red}%})\$"
local ret_num="%(?: :%F{red} [%?] )"

r_prompt() {
  setopt localoptions extendedglob
  if [[ "$(jobs)" != "" ]]; then
    jobs_str=$(jobs | sed -nr 's/(\S+)\s+\S+\s+\S+\s+(.*)/ \1 "\2" /p' | tr '\n' '|')
    ((len=${#${jobs_str}}-1))
    printf "%${COLUMNS}s\r" ${jobs_str:0:$len}
  fi
}

PROMPT='
%B%F{blue}${dirs}
%F{white}$(r_prompt)%B%F{green}%n@%m %F{cyan}%~/ %F{magenta}${vcs_info_msg_0_}%b%F{yellow}${timer_show}%B
%F{yellow}%D{%H:%M}%}%b${ret_num}${ret_status}%b%k%f '

# }}}

# Keybindings {{{
bindkey -e
bindkey '^[' vi-cmd-mode
bindkey '^[[Z' reverse-menu-complete
bindkey '^[%' vi-match-bracket
bindkey -s "^Z" "fg\n"
bindkey '^_' backward-kill-word

local-history-widget() {
  local selected
  selected=$(retrace | fzf --tac) || return
  BUFFER="$selected"
  CURSOR=${#BUFFER}
}
zle -N local-history-widget
bindkey '^[r' local-history-widget

# split-window() {
#   tmux split-window -h "tmux select-pane -l; echo -e $1\\\n-----\\\n; $1; read"
# }
# stty -ixon # Unbind current ctrl+s behavior
# launch-in-split() { # Launch command in new tmux split
#   if [[ -n "$TMUX" ]]; then
#     BUFFER="split-window \"$BUFFER\""
#     zle accept-line
#   fi
# }
# zle -N launch-in-split
# bindkey "^s" launch-in-split
#
# split-window2() {
#   tmux split-window -h "tmux select-pane -l; echo -e $1\\\n-----\\\n; $1"
# }
# launch-in-split2() { # Launch command in new tmux split
#   if [[ -n "$TMUX" ]]; then
#     BUFFER="split-window2 \"$BUFFER\""
#     zle accept-line
#   fi
# }
# zle -N launch-in-split2
# bindkey "^[^S" launch-in-split2
# }}}

# Completion {{{
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on

# eval "$(dircolors -b)"  # Adds more colors to ls
zstyle ':completion:*' menu select=2 search=yes
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' group-name ''
zstyle ':completion:*' complete-options true

zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
# }}}
