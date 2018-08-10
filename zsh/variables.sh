# Bash variables

# history
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

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

PROMPT_COMMAND=__prompt_command

# ls --color
ls_dir="di=1;95:" # Directories are bold and pink 
ls_fi="fi=0;97:" # Normal files are white
ls_ex="ex=1;91:" # Executables are bold and light green
ls_ln="ln=0;91:" # Symlinks are red
ls_mi="mi=9;37:" # Missing symlinks are strikethrough and grey
ls_or="or=9;90:" # Orphaned symlinks are strikethrough and dark grey

export LS_COLORS="$ls_dir$ls_fi$ls_ex$ls_ln$ls_mi$ls_or"

#colors for man pages
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}
