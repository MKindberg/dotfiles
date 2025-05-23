#!/bin/bash

dot_dir=$(git rev-parse --show-toplevel)

git submodule init
git submodule update

declare -A INCLUDE_STRINGS
INCLUDE_STRINGS=(
  [zsh]="source $dot_dir/zshrc"
  [bash]="source $dot_dir/bashrc"
  [git]="[include]\n\tpath=$dot_dir/gitconfig"
  [tmux]="source-file $dot_dir/tmux.conf"
  [vim]="source $dot_dir/vimrc"
  [nvim]="luafile $dot_dir/vimrc.lua"
  [wezterm]="dofile '$dot_dir/wezterm.lua'"
  [ghostty]="config-file = $dot_dir/ghostty_config"
)

declare -A DOTFILES
DOTFILES=(
  [zsh]="$HOME/.zshrc"
  [bash]="$HOME/.bashrc"
  [git]="$HOME/.gitconfig"
  [tmux]="$HOME/.tmux.conf"
  [vim]="$HOME/.vimrc"
  [nvim]="$HOME/.config/nvim/init.vim"
  [wezterm]="$HOME/.wezterm.lua"
  [ghostty]="$HOME/.config/ghostty/config"
)

declare -A GREP_PATTERNS
for key in "${!INCLUDE_STRINGS[@]}"; do
  GREP_PATTERNS[$key]=${INCLUDE_STRINGS[$key]}
done
GREP_PATTERNS+=([git]="\spath=$dot_dir/gitconfig")

install() {
  local file name str
  name="$1"
  file="${DOTFILES[$name]}"
  str="${INCLUDE_STRINGS[$name]}"
  pat="${GREP_PATTERNS[$name]}"
  if eval "grep -x \"$pat\" $file" &> /dev/null; then
    echo "$name installed"
    return
  fi
  read -rp "Do you want to install $name to $file? (y/n/e/a) " -n 1
  echo # newline
  # Abort
  if [[ $REPLY =~ ^[Aa]$ ]]; then # Abort
    exit
  elif [[ $REPLY =~ ^[Ee]$ ]]; then # Edit
    read -rp "Enter new file name: "
    echo # newline
    file="$REPLY"
  elif [[ $REPLY =~ ^[Yy]$ ]]; then # Yes
    : # Nothing to do here
  else # No
    return
  fi

  mkdir -p $(dirname $file)
  if test -s "$file"; then
    eval "sed -i \"1i $str\" $file"
  else
    echo -e "$str" > "$file"
  fi
}

for pgm in "${!DOTFILES[@]}"; do
  install "$pgm"
done
