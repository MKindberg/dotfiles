" Run with: :source % | e

set rtp+=~/dotfiles/lua
runtime vimrc.lua

" }}}

" Settings {{{
set mouse=
set spell

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
