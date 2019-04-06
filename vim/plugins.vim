if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree' " A better file explorer
Plug 'vim-airline/vim-airline' " A nicer status line
"Plug 'vim-syntastic/syntastic' " Syntax checker
"Plug 'Valloric/YouCompleteMe' " Always on autocomplete
Plug 'Raimondi/delimitMate' " Automatically close parantheses etc.
"Plug 'docunext/closetag.vim' " Automatically close html tags
"Plug 'ervandew/supertab' " Autocomplete with tab
Plug 'majutsushi/tagbar' " Show tags in current file
Plug '~/dotfiles/modules/fzf' " Fuzzy finding
Plug 'junegunn/fzf.vim' " Fuzzy finding
Plug 'tpope/vim-fugitive'
call plug#end()
