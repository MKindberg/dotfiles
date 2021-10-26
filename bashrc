# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return
BASH_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

source ~/dotfiles/shrc

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# History Options
#
# Don't put duplicate lines in the history.
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.

# Functions {{{

function PS1_pscount {
  ps -a | wc -l
}

# }}}

# Aliases {{{

alias reload='source ~/.bashrc'

# }}}

# Prompt {{{
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=1

__prompt_command() {

  local EXIT="$?"

  # colors
  black="\[\033[0;38;5;0m\]"
  red="\[\033[01;31m\]"
  orange="\[\033[0;38;5;130m\]"
  green="\[\033[01;32;1m\]"
  yellow="\[\033[01;33m\]"
  blue="\[\033[0;38;5;4m\]"
  bblue="\[\033[0;38;5;12m\]"
  magenta="\[\033[0;38;5;55m\]"
  cyan="\[\033[0;38;5;6m\]"
  white="\[\033[0;0m\]"
  coldblue="\[\033[0;38;5;33m\]"
  smoothblue="\[\033[0;38;5;111m\]"
  iceblue="\[\033[01;36m\]"
  turqoise="\[\033[0;38;5;50m\]"
  smoothgreen="\[\033[0;38;5;42m\]"

  if [ $EXIT != 0 ]; then
    status="[Error: "$EXIT"]"
  else
    status=""
  fi

# data
  user="\u@\h"
  path="\w"
  processes="ps: `PS1_pscount`"
  time="\D{%H:%M}"
  gitbranch="\$(__git_ps1)"
  end="\$"

  export PS1="\n$green$user $iceblue$path $red$gitbranch $magenta$status \n$yellow$time $white$end "

}
# }}}

# Completion options {{{
bind TAB:menu-complete
bind '"\e[Z": menu-complete-backward'
bind "set show-all-if-ambiguous on"
# }}}
