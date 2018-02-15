#! bin/zsh
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
  echo ""
}

function precmd() {
  if [ $timer ]; then
    local timer_time=$(($SECONDS - $timer))
    _lineup=$'\e[1A'
    _linedown=$'\e[1B'
    if (( $timer_time > 5 )) ; then
      RPROMPT="%{${_lineup}%} %b%F{yellow}(${timer_time}s)%B%{${_linedown}%}"
    else
      RPROMPT=""
    fi
    unset timer
  fi
}

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
local ret_num="%(?: :%F{red} [%?] )"
PROMPT='
%B%F{green}%n@%m %F{cyan}%~/ %F{magenta}`git_branch`${timer_show}
%F{yellow}%D{%H:%M}%}%b${ret_num}${ret_status}%b%k%f '

