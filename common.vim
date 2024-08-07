" Settings {{{
set cursorline " Set line highlight.

set showmatch " Show matching brackets.

set incsearch " Search when typing.
set hlsearch  " Highlight search matches.
set nowrapscan " Don't wrap when searching.

set scrolloff=3 " Min lines above and below cursor.

set lazyredraw

" Tabs
set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent
set expandtab
set shiftround

set linebreak " Don't break words when wrapping.
set breakindent " Keep indentation for wrapped lines.

set nojoinspaces " Only insert one space when joining lines.
" Window splitting
set splitright
set splitbelow

set showmode


set listchars=tab:>>,trail:-,
set list

set noerrorbells

set pastetoggle=<F12>

set wildmenu

let g:vim_json_conceal=0
let g:markdown_syntax_conceal=0
" }}}
