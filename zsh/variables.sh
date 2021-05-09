# Bash variables

path+=~/dotfiles/modules/diff-so-fancy
# history
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=500
HISTSIZE=2000
#setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY


export LESS=R

if [[ -n $TMUX ]]; then
  export TERM=screen-256color
else
  export TERM=xterm-256color
fi


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

FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --no-mouse"
