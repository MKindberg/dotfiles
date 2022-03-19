" Run with: :source % | e
let mapleader="\<SPACE>"
let maplocalleader=","

" Plugins {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:polyglot_disabled = ['markdown']

" Plugin list {{{
call plug#begin('~/.vim/plugged')
Plug 'Raimondi/delimitMate' " Automatically close parantheses etc.
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'} " Show tags in current file
Plug '~/dotfiles/modules/fzf' " Fuzzy finding
Plug 'junegunn/fzf.vim' " Fuzzy finding
Plug 'tpope/vim-fugitive' " Git commands
Plug 'luochen1990/rainbow' " Rainbow paranthesis
Plug 'sainnhe/sonokai' " Colorscheme
Plug 'Yggdroot/indentLine' " Show indentation markers
Plug 'szw/vim-maximizer'
if has('nvim-0.5')
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'romgrk/nvim-treesitter-context'
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'gennaro-tedesco/nvim-peekup' " Preview registers
  Plug 'beauwilliams/focus.nvim' " Increase width of active window
  Plug 'neovim/nvim-lspconfig'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'p00f/clangd_extensions.nvim'
  Plug 'nvim-lua/lsp-status.nvim'
  Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
  Plug 'puremourning/vimspector'
  Plug 'simrat39/rust-tools.nvim'
  Plug 'numToStr/Comment.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'TimUntersberger/neogit'
  "Plug 'npxbr/glow.nvim' " Markdown preview
else
  Plug 'tpope/vim-commentary'
  Plug 'sheerun/vim-polyglot' " Better syntax highlight
endif
"Plug 'scrooloose/nerdtree' " A better file explorer
"Plug 'docunext/closetag.vim' " Automatically close html tags
"Plug 'easymotion/vim-easymotion'
"Plug 'nbardiuk/vim-gol'
"Plug 'ervandew/supertab' " Autocomplete with tab
"Plug 'szw/vim-tags' " Show all tags in file
call plug#end()
" }}}

" Fugitive {{{
nnoremap <leader>gb <cmd>Git blame<cr>
nnoremap <leader>gg :Ggrep 
nnoremap <leader>gs <cmd>Git<cr>
nnoremap <leader>gl <cmd>Gclog!<cr>
nnoremap <leader>gd <cmd>Gvdiffsplit<cr>
nnoremap <leader>gm <cmd>Git mergetool -y<cr>
nnoremap <leader>ga <cmd>Gwrite<cr>
nnoremap <leader>gc <cmd>Git commit<cr>
nnoremap <leader>g <cmd>Neogit<cr>
" }}}

" indentLine {{{
let g:indentLine_char = '▏'
" }}}

if has('nvim-0.5')
  set rtp+=~/dotfiles/lua
  runtime vimrc.lua
endif
" Cscope {{{

set cscopetag
set csprg=gtags-cscope
if !empty(expand(glob("GTAGS")))
  set nocscopeverbose
  cs add GTAGS
  set cscopeverbose
endif

if has('nvim-0.5')
  set cscopequickfix=s-,f-,g-,c-,d-,i-,t-,e-
  nnoremap <C-c>s :cs find s <C-R>=expand("<cword>")<CR><CR><cmd>Telescope quickfix<cr>
  nnoremap <C-c>g :cs find g <C-R>=expand("<cword>")<CR><CR><cmd>Telescope quickfix<cr>
  nnoremap <C-c>c :cs find c <C-R>=expand("<cword>")<CR><CR><cmd>Telescope quickfix<cr>
  nnoremap <C-c>t :cs find t <C-R>=expand("<cword>")<CR><CR><cmd>Telescope quickfix<cr>
  nnoremap <C-c>e :cs find e <C-R>=expand("<cword>")<CR><CR><cmd>Telescope quickfix<cr>
  nnoremap <C-c>f :cs find f <C-R>=expand("<cfile>")<CR><CR><cmd>Telescope quickfix<cr>
  nnoremap <C-c>i :cs find i <C-R>=expand("%:t")<CR><CR><cmd>Telescope quickfix<cr>
  nnoremap <C-c>d :cs find d <C-R>=expand("<cword>")<CR><CR><cmd>Telescope quickfix<cr>
else
  nnoremap <C-c>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-c>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-c>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-c>t :cs find t <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-c>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-c>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nnoremap <C-c>i :cs find i <C-R>=expand("%:t")<CR><CR>
  nnoremap <C-c>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif
nnoremap <C-c>h :cs help <CR>

nnoremap <C-c><C-v>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-c><C-v>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-c><C-v>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-c><C-v>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-c><C-v>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-c><C-v>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-c><C-v>i :vert scs find i <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-c><C-v>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

nnoremap <C-c><C-s> :cs find s 
nnoremap <C-c><C-g> :cs find g 
nnoremap <C-c><C-c> :cs find c 
nnoremap <C-c><C-t> :cs find t 
nnoremap <C-c><C-e> :cs find e 
nnoremap <C-c><C-f> :cs find f 
nnoremap <C-c><C-i> :cs find i 
nnoremap <C-c><C-d> :cs find d 

" }}}

" }}}

" Key bindings {{{
let s:activatedh = 0
function! ToggleH()
  if s:activatedh
    let s:activatedh = 1
    match ErrorMsg '\(\%>80v.\+\|\s\+$\)'
  else
    let s:activatedh = 0
    match none
  endif
endfunction
nnoremap <Leader>l :call ToggleH() <CR>

let s:foldcol = 0
function! FoldColumnToggle()
    if s:foldcol
        setlocal foldcolumn=0
        let s:foldcol = 0
    else
        setlocal foldcolumn=auto:9
        let s:foldcol = 1
    endif
endfunction
nnoremap <Leader>f :call FoldColumnToggle() <CR>

inoremap ^_ <esc>wdbi

cnoremap Q<cr> q<cr>
cnoremap W<cr> w<cr>
cnoremap WQ<cr> wq<cr>

set pastetoggle=<F12>
noremap <F5> :e <CR>
noremap <F4> :RainbowToggle <CR>
noremap <F2> :NERDTreeToggle <CR>
noremap <F3> :TagbarToggle<CR>
noremap <C-L> :set relativenumber! <CR>
noremap <S-H> :set cursorline! <CR>
noremap <C-P> :FZF <CR>
noremap & :Lines <CR>
noremap ¤ $

noremap <Leader>h :hi CursorLine cterm=bold ctermbg=black <CR>
"            \:set cursorline! <CR>
noremap <Leader>rn :set relativenumber! <CR>
noremap <Leader>n :set number! <CR>
noremap <Leader>s :if exists("g:syntax_on") <Bar>
            \ syntax off <Bar>
            \ else <Bar>
            \ syntax enable <Bar>
            \ endif <CR>
            \ :hi CursorLine cterm=bold ctermbg=black <CR>

noremap <Leader><Leader> za
" open vimrc in new split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>evv <cmd>tabnew ~/dotfiles/vimrc<cr><cmd>vsplit ~/dotfiles/lua/vimrc.lua<cr>
" source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
" surround word with "
:nnoremap <space>" ea"<esc>bi"<esc>

nnoremap <M-m> :Man <C-R>=expand("<cword>")<CR><CR>

if has('nvim')
  " For moving in wrapped text
  noremap <A-k> gk
  noremap <A-j> gj
  " Move in quickfix list
  nnoremap <A-n> :cn<cr>
  nnoremap <A-p> :cp<cr>
else
  noremap <Esc>k gk
  noremap <Esc>j gj
  noremap <Esc>r :!./%<CR>
endif

"let g:EasyMotion_do_mapping = 0
"nnoremap <Space>f <Plug>(easymotion-overwin-f)
"nnoremap <Space>w <Plug>(easymotion-overwin-w)

inoremap jj <Esc>
" Make word uppercase
:inoremap <c-u> <esc>viwUi

" Save as root even when file wasn't open with sudo
cnoremap w!! w !sudo tee > /dev/null %

map <leader>c gc
map <leader>m :MaximizerToggle<cr>

noremap <leader>dd :call vimspector#Launch()<CR>
noremap <leader>dn :call vimspector#StepOver()<CR>
noremap <leader>ds :call vimspector#StepInto()<CR>
noremap <leader>dsu :call vimspector#StepOut()<CR>
noremap <leader>dc :call vimspector#Continue()<CR>
noremap <leader>db :call vimspector#ToggleBreakpoint()<CR>
noremap <leader>dfu :call vimspector#UpFrame()<CR>
noremap <leader>dfd :call vimspector#DownFrame()<CR>
noremap <leader>dcc :call vimspector#RunToCursor()<CR>
noremap <leader>dr :call vimspector#Restart()<CR>
noremap <leader>de :call vimspector#Stop()<CR>

noremap <leader>1 <cmd>buffer 1<cr>
noremap <leader>2 <cmd>buffer 2<cr>
noremap <leader>3 <cmd>buffer 3<cr>
noremap <leader>4 <cmd>buffer 4<cr>
noremap <leader>5 <cmd>buffer 5<cr>
noremap <leader>6 <cmd>buffer 6<cr>
noremap <leader>7 <cmd>buffer 7<cr>

noremap <localleader><localleader> gt
noremap <localleader>1 1gt
noremap <localleader>2 2gt
noremap <localleader>3 3gt
noremap <localleader>4 4gt
noremap <localleader>5 5gt
noremap <localleader>6 6gt
" }}}

" Settings {{{
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


set listchars=tab:>>,trail:-,
set list

set noerrorbells

" Colorscheme
colorscheme sonokai
highlight CursorLine cterm=bold ctermbg=black
highlight ColorColumn ctermbg=none ctermfg=darkgrey " Needed for vim-diminactive plugin
highlight Normal ctermbg=None

highlight ExtraWhitespace ctermbg=red
syntax match ExtraWhitespace /\s\+$/
highlight LeadingTab ctermbg=blue
syntax match LeadingTab /^\t\+/

" => Turn persistent undo on
" "    means that you can undo even when you close a buffer/VIM

try
  " Seems like vim and nvim undo-files aren't compatible
  if has('nvim')
    set undodir=~/.vim_runtime/temp_dirs/nvim-undodir
  else
    set undodir=~/.vim_runtime/temp_dirs/undodir
  endif
  set undofile
catch
endtry

syntax manual
augroup focus_active
  autocmd!
  autocmd BufLeave * set syntax=OFF
  autocmd BufEnter * set syntax=ON
augroup END
" }}}

" Language Specific {{{
function! StripTrailingWhitespace()
  let save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction

" c/c++
augroup c
  autocmd!
  autocmd BufWritePre *.h,*.c,*.cpp,*.hpp call StripTrailingWhitespace()
  autocmd Filetype *.h,*.c,*.cpp,*.hpp setlocal commentstring=//%s
augroup END

" xml
augroup xml
  autocmd!
  autocmd BufWritePre *.xml call StripTrailingWhitespace()
augroup END

" python
augroup python
  autocmd!
  autocmd FileType python,bzl setlocal shiftwidth=4
  autocmd FileType python,bzl setlocal tabstop=4
  autocmd FileType python,bzl setlocal softtabstop=4
augroup END

" Git commit (Might not work, put options in ~/.vim/ftplugin/gitcommit.vim
" instead)
augroup git
  autocmd!
  autocmd FileType gitcommit setlocal spell
augroup END

" Vim
augroup vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldlevel=0
augroup END

" Lua
augroup lua
  autocmd!
  autocmd BufRead *vimrc.lua setlocal foldmethod=marker
  autocmd BufRead *vimrc.lua setlocal foldlevel=0
augroup END

augroup shell_rc
  autocmd!
  autocmd BufRead *shrc setlocal foldmethod=marker
  autocmd BufRead *shrc setlocal foldlevel=0
augroup END
" }}}

" Autocorrections {{{
ab pritnf printf

" }}}

" StatusLine {{{
" function! LspStatus() abort
"     let sl = ''
"     if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
"         let sl.='E:' .luaeval("vim.lsp.diagnostic.get_count(0, [[Error]])") . ', '
"         let sl.='W:' .luaeval("vim.lsp.diagnostic.get_count(0, [[Warning]])")
"     else
"         let sl.='Lsp off'
"     endif
"     return sl
" endfunction
"   hi NormalColor ctermbg=Green ctermfg=0
"   hi InsertColor ctermbg=Cyan ctermfg=0
"   hi ReplaceColor ctermbg=DarkCyan ctermfg=0
"   hi VisualColor ctermbg=Blue ctermfg=0
"   hi CommandColor ctermbg=Red ctermfg=0
"   hi SelectColor ctermbg=White ctermfg=0
"   hi DefaultColor ctermbg=Gray ctermfg=0
"   let modes =  {
"         \'n': ["%#NormalColor#", "  NORMAL "],
"         \'i': ["%#InsertColor#", "  INSERT "],
"         \'v': ["%#VisualColor#", "  VISUAL "],
"         \'V': ["%#VisualColor#", "  VISUAL LINE "],
"         \'': ["%#VisualColor#", "  VISUAL BLOCK "],
"         \'c': ["%#CommandColor#", "  COMMAND "],
"         \'R': ["%#ReplaceColor#", "  REPLACE "],
"         \'s': ["%#SelectColor#", "  SELECT "],
"         \'S': ["%#SelectColor#", "  SELECT LINE "],
"         \'': ["%#SelectColor#", "  SELECT BLOCK "],
"         \}
"   function! AllStatus()
"     let statusline=""
"     let statusline.="%#DefaultColor#"
"     let statusline.="\ %f"
"     let statusline.="%m"
"     let statusline.='%{(&readonly || !&modifiable) ? " " : ""}'
"     let statusline.="%="
"     let statusline.="\ %{LspStatus()}"
"     let statusline.="%="
"     let statusline.="%{FugitiveStatusline()}"
"     let statusline.="%="
"     let statusline.="%l/%L,%c"
"     let statusline.="%y"
"     return statusline
"   endfunction
"
"   function! ActiveStatus()
"     let statusline=""
"     let statusline.="%{%modes[mode()][0]%}%{modes[mode()][1]}"
"     let statusline.=AllStatus()
"     return statusline
"   endfunction
"
"   function! InactiveStatus()
"     let statusline=""
"     let statusline.=AllStatus()
"     return statusline
"   endfunction
"
"   autocmd BufEnter,WinEnter * setlocal statusline=%!ActiveStatus()
"   autocmd BufLeave,WinLeave * setlocal statusline=%!InactiveStatus()
"   " }}}
