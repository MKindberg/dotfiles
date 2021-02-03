if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:polyglot_disabled = ['markdown']
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree' " A better file explorer
Plug 'vim-airline/vim-airline' " A nicer status line
"Plug 'vim-syntastic/syntastic' " Syntax checker
"Plug 'Valloric/YouCompleteMe' " Always on autocomplete
Plug 'Raimondi/delimitMate' " Automatically close parantheses etc.
"Plug 'docunext/closetag.vim' " Automatically close html tags
Plug 'ervandew/supertab' " Autocomplete with tab
Plug 'majutsushi/tagbar' " Show tags in current file
Plug '~/dotfiles/modules/fzf' " Fuzzy finding
Plug 'junegunn/fzf.vim' " Fuzzy finding
Plug 'tpope/vim-fugitive'
Plug 'szw/vim-tags'
Plug 'easymotion/vim-easymotion'
Plug 'luochen1990/rainbow'
Plug 'nbardiuk/vim-gol'
Plug 'blueyed/vim-diminactive'
Plug 'sainnhe/sonokai'
Plug 'sheerun/vim-polyglot'
Plug 'Yggdroot/indentLine'
if has('nvim-0.5')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'romgrk/nvim-treesitter-context'
endif
"Plug 'garbas/vim-snipmate' " Autogenerate code
call plug#end()

if has('nvim-0.5')
  lua <<EOF
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
    },
    indent = {
      enable = true
    },
    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = true },
    },
  }
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=20
endif
