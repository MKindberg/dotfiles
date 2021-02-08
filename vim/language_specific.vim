function! StripTrailingWhitespace()
  let save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction

" c/c++
autocmd BufWritePre *.h,*.c,*.cpp,*.hpp call StripTrailingWhitespace()
" cscript template
autocmd FileType cpp iabbrev cscript #!/bin/bash<cr>tail +3 $0 \| g++ -std=c++17 -Wall -Werror -O3 -x c++ - && exec ./a.out
autocmd FileType c iabbrev cscript #!/bin/bash<cr>tail +3 $0 \| gcc -std=c17 -Wall -Werror -O3 -x c - && exec ./a.out

" xml
autocmd BufWritePre *.xml call StripTrailingWhitespace()

" python
autocmd FileType python setlocal shiftwidth=4
autocmd FileType python setlocal tabstop=4
autocmd FileType python setlocal softtabstop=4

" Git commit (Might not work, put options in ~/.vim/ftplugin/gitcommit.vim
" instead)
autocmd FileType gitcommit setlocal spell

