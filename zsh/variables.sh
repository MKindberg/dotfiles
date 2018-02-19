# Bash variables

# history
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

export TERM=xterm-256color

# ls --color
ls_dir="di=1;95:" # Directories are bold and pink 
ls_fi="fi=0;97:" # Normal files are white
ls_ex="ex=1;91:" # Executables are bold and light green
ls_ln="ln=0;91:" # Symlinks are red
ls_mi="mi=9;37:" # Missing symlinks are strikethrough and grey
ls_or="or=9;90:" # Orphaned symlinks are strikethrough and dark grey

export LS_COLORS="$ls_dir$ls_fi$ls_ex$ls_ln$ls_mi$ls_or"
