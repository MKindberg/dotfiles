#!/bin/zsh

cd ~/dotfiles/modules

for d in $(find -maxdepth 1 -mindepth 1 -type d)
do
  cd $d
  git pull origin master
  cd ..
done
