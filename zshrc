#!/bin/zsh

source ~/dotfiles/shrc

autoload -U compinit
compinit
autoload -Uz zmv
# Plugins {{{
if [[ -a ~/.zi/bin/zi.zsh ]]; then
  source ~/.zi/bin/zi.zsh

  zi ice lucid as"program" pick"bin/git-dsf"
  zi light z-shell/zsh-diff-so-fancy

  zi light z-shell/F-Sy-H

  zi ice pick"zsh-autosuggestions.zsh" $TURBO
  zi light zsh-users/zsh-autosuggestions

  zi snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
  zi snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh

  zi snippet https://github.com/rupa/z/blob/master/z.sh

  zi snippet https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh

else
  echo "zi not installed"
fi
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

CASE_SENSITIVE="true" # Case insensitive completion

ENABLE_CORRECTION="true" # Command autocorrection
# }}}

# Functions {{{
function PS1_pscount {
  ps -a | wc -l
}

__git_files () {
  _wanted files expl 'local files' _files
}
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
# }}}

# Prompt {{{
setopt PROMPT_SUBST

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=1

function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  if [ $timer ]; then
    if [[ $(($SECONDS - $timer)) > 10 ]]; then
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
%F{white}$(r_prompt)%B%F{green}%n@%m %F{cyan}%~/ %F{magenta}`__git_ps1` %b%F{yellow}${timer_show}%B
%F{yellow}%D{%H:%M}%}%b${ret_num}${ret_status}%b%k%f '

# }}}

# Keybindings {{{
bindkey -e
bindkey '^[' vi-cmd-mode
bindkey '^[[Z' reverse-menu-complete
bindkey '^[%' vi-match-bracket
bindkey -s "^Z" "fg\n"
bindkey '^_' backward-kill-word

split-window() {
  tmux split-window -h "tmux select-pane -l; echo -e $1\\\n-----\\\n; $1; read"
}
stty -ixon # Unbind current ctrl+s behavior
launch-in-split() { # Launch command in new tmux split
  if [[ -n "$TMUX" ]]; then
    BUFFER="split-window \"$BUFFER\""
    zle accept-line
  fi
}
zle -N launch-in-split
bindkey "^s" launch-in-split

split-window2() {
  tmux split-window -h "tmux select-pane -l; echo -e $1\\\n-----\\\n; $1"
}
launch-in-split2() { # Launch command in new tmux split
  if [[ -n "$TMUX" ]]; then
    BUFFER="split-window2 \"$BUFFER\""
    zle accept-line
  fi
}
zle -N launch-in-split2
bindkey "^[^S" launch-in-split2
# }}}

# Completion {{{
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on

zstyle ':completion:*' menu select=2 eval "$(dircolors -b)" search=yes
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' group-name ''
zstyle ':completion:*' complete-options true

zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

zstyle ':autocomplete:tab:*' widget-style menu-complete
# }}}
