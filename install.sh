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
)

declare -A DOTFILES
DOTFILES=(
  [zsh]="$HOME/.zshrc"
  [bash]="$HOME/.bashrc"
  [git]="$HOME/.gitconfig"
  [tmux]="$HOME/.tmux.conf"
  [vim]="$HOME/.vimrc"
  [nvim]="$HOME/.config/nvim/init.vim"
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
  read -rp "Do you want to install $name to $file? (y/n/e/a) " -n 1
  echo # newline
  # Abort
  if [[ $REPLY =~ ^[Aa]$ ]]; then
    exit
  fi
  # No
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    return
  fi
  # Edit
  if [[ $REPLY =~ ^[Ee]$ ]]; then
    read -rp "Enter new file name: "
    echo # newline
    file="$REPLY"
  fi
  # Yes
  if eval "grep -x \"$pat\" $file" &> /dev/null; then
    echo "Skipping $name, already installed"
    return
  fi

  if test -f "$file"; then
    eval "sed -i \"1i $str\" $file"
  else
    echo -e "$str" > "$file"
  fi
}

for pgm in "${!DOTFILES[@]}"; do
  install "$pgm"
done
