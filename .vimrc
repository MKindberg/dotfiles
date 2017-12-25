


set cursorline " set line highlight

set showmatch " show matching brackets

set incsearch " search when typing
set hlsearch  " highlight search matches

set wildmenu " show options when completing

set scrolloff=3 " min lines above and below cursor

set foldmethod=indent " fold indented code

" Tabs
set shiftwidth=2
set autoindent
set tabstop=2
set softtabstop=2

" Window splitting
set splitright
set splitbelow

set pastetoggle=<F12> 
set showmode

" Key mappings
map <F5> :e <CR>


" Statusline
set laststatus=2
set statusline=%<%F\ %h%m%r%y%=%-14.(%l,%c%V%)\ %P

set listchars=tab:>>,trail:.,
set list

set noerrorbells
