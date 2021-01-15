function! StripTrailingWhitespace()
  let save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction

" c/c++
autocmd BufWritePre *.h,*.c,*.cpp,*.hpp call StripTrailingWhitespace()

" xml
autocmd BufWritePre *.xml call StripTrailingWhitespace()

" python
autocmd BufNew,BufEnter *.py setlocal shiftwidth=2
autocmd BufNew,BufEnter *.py setlocal tabstop=2
autocmd BufNew,BufEnter *.py setlocal softtabstop=2

