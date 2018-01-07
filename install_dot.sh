#!/bin/bash
DOT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
echo "Moving folder to home folder"
mv $DOT_DIR ~

function backup {
  backup_folder="$HOME/dotfiles_backup"
  mkdir -p $backup_folder
  if [ $1 == "bash" ] || [ $1 == "all" ]; then
    cp ~/.bashrc ${backup_folder}/
  fi
  if [ $1 == "vim" ] || [ $1 == "all" ]; then
    cp ~/.vimrc ${backup_folder}/
  fi
}

function install {
  if [ -n $2 -a $2 == "clean" ]; then
    if [ $1 == "bash" ] || [ $1 == "all" ]; then
      echo "" > ~/.bashrc
    fi
    if [ $1 == "vim" ] || [ $1 == "all" ]; then
      echo "" > ~/.vimrc
    fi
  fi

  if [ $1 == "bash" ] || [ $1 == "all" ]; then
    echo -e "source ${DOT_DIR}/bash/bashrc\n$(cat $HOME/.bashrc)" > ~/.bashrc
    installed=1
  fi
  if [ $1 == "vim" ] || [ $1 == "all" ]; then
    echo -e "source ${DOT_DIR}/vim/vimrc\n$(cat $HOME/.vimrc)" > ~/.vimrc
    installed=1
  fi
  if [ -z $installed ]; then
    echo "Invalid first argument, must be \'bash\', \'vim\' or \'all\'"
  fi
}
echo "Backing up old scipts"
backup
echo "Installing new scripts"
install $1 $2

