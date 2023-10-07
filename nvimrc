" Run with: :source % | e
let mapleader="\<SPACE>"
let maplocalleader=","

source ~/dotfiles/common.vim

" indentLine {{{
let g:indentLine_char = '▏'
" }}}

set rtp+=~/dotfiles/lua
runtime vimrc.lua

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
noremap <S-H> :set cursorline! <CR>
noremap <C-P> :Files <CR>
noremap & :Lines <CR>
noremap ¤ $
noremap ä $
noremap ö ^

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
nnoremap <leader>evv <cmd>tabnew ~/dotfiles/nvimrc<cr><cmd>vsplit ~/dotfiles/lua/vimrc.lua<cr>
" source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
" surround word with "
:nnoremap <space>" ea"<esc>bi"<esc>

nnoremap <M-m> :Man <C-R>=expand("<cword>")<CR><CR>

" For moving in wrapped text
noremap <A-k> gk
noremap <A-j> gj
" Move in quickfix list
nnoremap <A-n> :cn<cr>
nnoremap <A-p> :cp<cr>

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
set mouse=
set spell

set wildmenu " Show options when completing.

" Colorscheme
colorscheme sonokai
highlight EndOfBuffer ctermbg=none
highlight CursorLine cterm=bold ctermbg=black
" highlight ColorColumn ctermbg=none ctermfg=darkgrey " Needed for vim-diminactive plugin
highlight Normal ctermbg=None
highlight NormalNC ctermbg=None

highlight ExtraWhitespace ctermbg=red
syntax match ExtraWhitespace /\s\+$/
highlight LeadingTab ctermbg=blue
syntax match LeadingTab /^\t\+/

" => Turn persistent undo on
" "    means that you can undo even when you close a buffer/VIM

try
  set undodir=~/.vim_runtime/temp_dirs/nvim-undodir
  set undofile
catch
endtry

" syntax manual
" augroup focus_active
"   autocmd!
"   autocmd BufLeave * set syntax=OFF
"   autocmd BufEnter * set syntax=ON
" augroup END

augroup line_number_active
  autocmd!
  autocmd BufLeave * set norelativenumber
  autocmd BufLeave * set nonumber
  autocmd BufEnter * set relativenumber
  autocmd BufEnter * set number
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

augroup json
  autocmd!
  autocmd BufRead *.json setlocal conceallevel=0
augroup END
augroup markdown
  autocmd!
  autocmd BufRead *.md setlocal conceallevel=0
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
