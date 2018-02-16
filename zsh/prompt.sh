#! bin/zsh

setopt PROMPT_SUBST

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=1

source /usr/lib/git-core/git-sh-prompt

function last_status() {
  export res=$?
  echo -n $res
  if [[ $res == 0 ]] then;
    echo -n \$
  else
    echo -n ($res)\$
  fi
}

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
}
local ret_status="%(?:%{%F{green}:%F{red}%})\$"
local ret_num="%(?: :%F{red} [%?] )"
PROMPT='
%B%F{green}%n@%m %F{cyan}%~/ %F{magenta}`__git_ps1` %b%F{yellow}${timer_show}%B
%F{yellow}%D{%H:%M}%}%b${ret_num}${ret_status}%b%k%f '
