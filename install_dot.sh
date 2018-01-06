#!/bin/bash
DOT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

function backup {
  local backup_folder="$HOME/dotfiles_backup"
  mkdir -p $backup_folder
  mv ~/.bashrc ${backup_folder}/
  mv ~/.vimrc ${backup_folder}/
}

function install_clean {
  echo "source ${DOT_DIR}/bash/bashrc" > ~/.bashrc
  echo "source ${DOT_DIR}/vim/vimrc" > ~/.vimrc
}

function install_append {
  echo -e "source ${DOT_DIR}/bash/bashrc\n$(cat ~/.bashrc)" > ~/.bashrc
  echo -e "source ${DOT_DIR}/vim/vimrc\n$(cat ~/.vimrc)" > ~/.vimrc
}

backup

if [ -n $1 ] -a [ $1 == "append" ]; then
  install_append
else
  install_clean
fi

