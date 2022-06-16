
# Variables {{{
 # set -gx PATH $PATH ~/dotfiles/bin set -gx PATH $PATH

set -x LANG en_US.UTF-8
set -x EDITOR 'nvim'
set -x LESS R

if test $TMUX
  set -x TERM screen-256color
else
  set -x TERM xterm-256color
end

# ls --color
set ls_dir "di 1;95:" # Directories are bold and pink
set ls_fi "fi 0;97:" # Normal files are white
set ls_ex "ex 1;91:" # Executables are bold and light green
set ls_ln "ln 0;91:" # Symlinks are red
set ls_mi "mi 9;37:" # Missing symlinks are strikethrough and grey
set ls_or "or 9;90:" # Orphaned symlinks are strikethrough and dark grey
set -x LS_COLORS "$ls_dir$ls_fi$ls_ex$ls_ln$ls_mi$ls_or"


# }}}

# Abbrevations {{{
abbr vim nvim

abbr ls ls -hFH --color=tty
abbr l 'ls'
abbr ll 'ls -l'
abbr la 'ls -A'

abbr df 'df -h'
abbr du 'du -h'

abbr - 'cd -'
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'
abbr ..... 'cd ../../../..'
abbr ...... 'cd ../../../../..'

abbr fn 'find -name'
abbr grep 'grep --color'

abbr cim vim

abbr gs 'git status'
abbr gst 'git status --untracked-files=no'
abbr gb 'git branch'
# abbr go 'git checkout'
abbr ga 'git add'
abbr gaa 'git add --all'
abbr gd 'git diff'
abbr gci 'git commit'
abbr grm 'git-rm'
abbr gmv 'git-mv'
abbr gti 'git'
abbr gco 'git commit'
abbr gcom 'git commit -m'
abbr gap 'git add -p'
abbr gdt 'git difftool'
abbr gg 'git grep -n --break --heading'
abbr gl 'git log'
# }}}

# Functions {{{

function fbr
  set branches $(git branch -vv)
  echo $branches
  set branch $(echo "$branches" | fzf +m)
  echo $branch
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
end

abbr --erase go
function go
  if count $argv > /dev/null
    git checkout "$argv"
  else
    fbr
  end
end

abbr --erase ga
function ga
  if count $argv > /dev/null
    echo 1
    git add "$argv"
  else
    echo 2
    local files
    if test $FZF_PREVIEW == 0
      set files $(git ls-files -m -o --exclude-standard -x "*" | fzf -m -0 )
    else
      set files $(git ls-files -m -o --exclude-standard -x "*" | fzf -m -0 --preview 'git diff --color=always {}' | diff-so-fancy)
    end
    test -n "$files" && echo "$files" | xargs -I{} git add {} && git status --short --untracked=no
  end
end

# }}}

# Keybinds {{{
bind \cz fg
# }}}

# Prompt {{{
function fish_prompt
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)
    set -q fish_color_status
    or set -g fish_color_status --background=red white

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix '->'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # Write pipestatus
    # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color $bold_flag $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

    if test "$CMD_DURATION" -gt 5000
        set run_time $(math -s 0 $CMD_DURATION/1000) s
    end

    echo ''
    echo -s (prompt_login)' ' (set_color $color_cwd) (prompt_pwd) (set_color purple)(fish_git_prompt) " " (set_color yellow) $run_time
    echo -s (set_color yellow)$(date +%R) $normal " " $prompt_status $suffix " "
end

# }}}
