function! StripTrailingWhitespace()
  let save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction

" c/c++
autocmd BufWritePre *.m,*.h,*.c,*.mm,*.cpp,*.hpp call StripTrailingWhitespace()

" xml
autocmd BufWritePre *.xml call StripTrailingWhitespace()
