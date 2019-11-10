#!/bin/bash

dot_dir=$(git rev-parse --show-toplevel)

git submodule init
git submodule update

# fzf
installed=$(fzf --version 2> /dev/null)
if [[ $installed == "" ]]; then
	read -p "Do you want to install fzf? " -n 1
	echo #newline
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		(cd $dot_dir/modules/fzf; ./install)
	fi
else
	echo "fzf already installed"
fi

# zsh
installed=$(grep "source $dot_dir/zsh/zshrc" ~/.zshrc.user ~/.zshrc 2> /dev/null)
if [[ -f ~/.zshrc.user && $installed == "" ]]; then
	read -p "Do you want to install zsh dotfile to ~/.zshrc.user? " -n 1
	echo #newline
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		sed -i "1i source $dot_dir/zsh/zshrc\n" ~/.zshrc.user
	fi
elif [[ $installed == "" ]]; then
	read -p "Do you want to install zsh dotfile to ~/.zshrc? " -n 1
	echo #newline
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		sed -i "1i source $dot_dir/zsh/zshrc\n" ~/.zshrc
	fi
else
	echo "zsh dotfile already installed"
fi

# bash
installed=$(grep "source $dot_dir/bash/bashrc" ~/.bashrc.user ~/.bashrc 2> /dev/null)
if [[ -f ~/.bashrc.user && $installed == "" ]]; then
	read -p "Do you want to install bash dotfile to ~/.bashrc.user? " -n 1
	echo #newline
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		sed -i "1i source $dot_dir/bash/bashrc\n" ~/.bashrc.user
	fi
elif [[ $installed == "" ]]; then
	read -p "Do you want to install bash dotfile to ~/.bashrc? " -n 1
	echo #newline
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		sed -i "1i source $dot_dir/bash/bashrc\n" ~/.bashrc.user
	fi
else
	echo "bash dotfile already installed"
fi

# vim
installed=$(grep "source $dot_dir/vim/vimrc" ~/.vimrc 2> /dev/null)
if [[ $installed == "" ]]; then
	read -p "Do you want to install vim dotfile to ~/.vimrc? " -n 1
	echo #newline
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		sed -i "1i source $dot_dir/bash/vimrc\n" ~/.vimrc
	fi
else
	echo "vim dotfile already installed"
fi

# tmux
installed=$(grep "source-file $dot_dir/tmux/tmux.conf" ~/.tmux.conf 2> /dev/null)
if [[ $installed == "" ]]; then
	read -p "Do you want to install tmux dotfile to ~/.tmux.conf? " -n 1
	echo #newline
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		sed -i "1i source $dot_dir/bash/tmux.conf\n" ~/.tmux.conf
	fi
else
	echo "tmux dotfile already installed"
fi

# git
installed=$(grep "path=$dot_dir/git/gitconfig" ~/.gitconfig 2> /dev/null)
if [[ $installed == "" ]]; then
	read -p "Do you want to install gitconfig dotfile to ~/.gitconfig? " -n 1
	echo #newline
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		sed -i "1i [include]\n\tpath=$dot_dir/git/gitconfig\n" ~/.gitconfig
	fi
else
	echo "git dotfile already installed"
fi
