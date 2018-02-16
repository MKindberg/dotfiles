#! bin/zsh

setopt PROMPT_SUBST

function git_branch() {
  local branch=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  if [[ -n $branch ]] ; then
    if [[ -n $(git status --porcelain) ]] ; then
      echo -n "(*"
    else
      echo -n "("
    fi
    echo -n "$branch)"
  fi
}

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
    if [[ $(($SECONDS - $timer)) > 0 ]]; then
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
%B%F{green}%n@%m %F{cyan}%~/ %F{magenta}$(git_branch) %b%F{yellow}${timer_show}%B
%F{yellow}%D{%H:%M}%}%b${ret_num}${ret_status}%b%k%f '

