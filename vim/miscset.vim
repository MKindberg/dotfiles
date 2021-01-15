set cursorline " Set line highlight.

set showmatch " Show matching brackets.

set incsearch " Search when typing.
set hlsearch  " Highlight search matches.
set nowrapscan " Don't wrap when searching.

set wildmenu " Show options when completing.

set scrolloff=3 " Min lines above and below cursor.

set lazyredraw

" Tabs
set shiftwidth=2
set tabstop=2
set softtabstop=2
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

" Statusline
"set laststatus=2
"set statusline=%<%F\ %h%m%r%y%=%-14.(%l,%c%V%)\ %P

set listchars=tab:>>,trail:.,
set list

set noerrorbells

" Colorscheme
colorscheme sonokai
hi CursorLine cterm=bold ctermbg=black
hi ColorColumn ctermbg=none ctermfg=darkgrey " Needed for vim-diminactive plugin
hi Normal ctermbg=None


" => Turn persistent undo on
" "    means that you can undo even when you close a buffer/VIM
try
  set undodir=~/.vim_runtime/temp_dirs/undodir
  set undofile
catch
endtry
