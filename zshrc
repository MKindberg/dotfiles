#! /bin/zsh

source ~/dotfiles/shrc

autoload -U compinit
compinit
# Plugins {{{
if [[ -a ~/.zinit/bin/zinit.zsh ]]; then
  source ~/.zinit/bin/zinit.zsh
  if [[ $ZSH_VERSION == 5.<3->* ]]; then
    #  zinit ice pick"zsh-autocomplete.plugin.zsh"
    #  zinit light marlonrichert/zsh-autocomplete

    #  zinit ice pick"fzf-tab.plugin.zsh"
    #  zinit light Aloxaf/fzf-tab

    TURBO=wait'!0'

  fi

  zinit ice pick"zsh-syntax-highlighting.zsh" $TURBO
  zinit light zsh-users/zsh-syntax-highlighting

  zinit ice pick"zsh-autosuggestions.zsh" $TURBO
  zinit light zsh-users/zsh-autosuggestions
else
  echo "zinit not installed"
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

zstyle ':completion:*' menu select=2 eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' special-dirs true

zstyle ':autocomplete:tab:*' widget-style menu-complete
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
# }}}

# Prompt {{{
setopt PROMPT_SUBST

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=1

source ~/dotfiles/git-prompt.sh

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

PROMPT='
%B%F{blue}${dirs}
%B%F{green}%n@%m %F{cyan}%~/ %F{magenta}`__git_ps1` %b%F{yellow}${timer_show}%B
%F{yellow}%D{%H:%M}%}%b${ret_num}${ret_status}%b%k%f '

# }}}

# Keybindings {{{
bindkey -e
bindkey '^[' vi-cmd-mode
bindkey '^[[Z' reverse-menu-complete
bindkey '^[%' vi-match-bracket
bindkey -s "^Z" "%\n"
bindkey '^_' backward-word

stty -ixon # Unbind current ctrl+s behavior
launch-in-split() { Launch command in new tmux split
  if [[ -n "$TMUX" ]]; then
    BUFFER="tmux split-window -h \"tmux select-pane -l; echo -e \\\"$BUFFER\n-----\n\\\"; $BUFFER; read\""
    zle accept-line
  fi
}
zle -N launch-in-split
bindkey "^s" launch-in-split
# }}}
