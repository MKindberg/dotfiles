#!/bin/bash

programs=( "vim" "bash" "zsh" "tmux" "git" )
files=( "vimrc" "bashrc" "zshrc" "tmux.conf" "gitconfig" )
CLEAN=0
BACKUP=1
ALL=0

function backup () {
  local filename=$1
  local backup_folder=~/.dotfiles_backup
  mkdir -p $backup_folder
  cp ~/.${filename} ${backup_folder}/
}

function getInstallCmd () {
  local program=$1
  case $program in
    vim)
      echo 'source ~/dotfiles/vim/vimrc'
    ;;
    bash)
      echo 'source ~/dotfiles/bash/bashrc'
    ;;
    zsh)
      echo 'source ~/dotfiles/zsh/zshrc'
    ;;
    tmux)
      echo 'source-file ~/dotfiles/tmux/tmux.conf'
    ;;
    git)
      echo "[include]\n\tpath=~/dotfiles/git/gitconfig"
    ;;
  esac
}

function getFilename () {
  local program=$1
  local j=0
  for prog in "${programs[@]}"
  do
    if [[ $program == $prog ]]; then
      echo $j
      return
    fi
    j=$((j+1))
  done
}

function installDotfile () {
  local program=$1
  local num=$(getFilename $program)
  local filename="${files[${num}]}"
  if [[ -z $filename ]]; then
    echo "Invalid argument $program"
    return
  fi
  if [[ $BACKUP == 1 ]]; then
    backup $filename
  fi
  if [[ $CLEAN == 1 ]]; then
    echo -e "$(getInstallCmd $program)" > ~/.$filename
  else
    echo -e "$(getInstallCmd $program)\n\n$(cat ~/.$filename)" > ~/.$filename
  fi
}

for arg in $@
do
  if [[ $arg == "-c" || $arg == "--clean" ]]; then
    CLEAN=1
  elif [[ $arg == "-n" || $arg == "--no-backup" ]]; then
    BACKUP=0
  elif [[ $arg == "all" ]]; then
    ALL=1
  else
    p+=$arg
  fi
done
if [[ $ALL == 1 ]]; then
  p=("${programs[@]}")
fi

for prog in "${p[@]}"
do
  installDotfile $prog
done
