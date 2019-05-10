let s:activatedh = 0 
function! ToggleH()
  if s:activatedh == 0
    let s:activatedh = 1 
    match ErrorMsg '\(\%>80v.\+\|\s\+$\)'
  else
    let s:activatedh = 0 
    match none
  endif
endfunction

imap ^_ <esc>wdbi

map :Q :q
map :W :w
map :WQ :wq

set pastetoggle=<F12n
map <F5> :e <CR>
map <F2> :NERDTreeToggle <CR>
map <F3> :TagbarToggle<CR>
map <C-L> :set relativenumber! <CR>
map <S-H> :set cursorline! <CR>
map <C-P> :FZF <CR>
map & :Lines <CR>

map <Space>h :hi CursorLine cterm=bold ctermbg=black <CR>
            \:set cursorline! <CR>
map <Space>rn :set relativenumber! <CR>
map <Space>n :set number! <CR>
map <Space>l :call ToggleH() <CR>
map <Space>s :if exists("g:syntax_on") <Bar>
            \ syntax off <Bar>  
            \ else <Bar>
            \ syntax enable <Bar>
            \ endif <CR>
            \ :hi CursorLine cterm=bold ctermbg=black <CR>
map <Space>t :terminal<CR>

" Cscope bindings
nmap <C-c>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-c>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-c>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>h :cs help <CR>

nmap <C-c><C-v>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-v>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-v>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-v>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-v>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-v>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-c><C-v>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-c><C-v>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

nmap <C-c><C-h>s scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-h>g scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-h>c scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-h>t scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-h>e scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-h>f scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-c><C-h>i scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-c><C-h>d scs find d <C-R>=expand("<cword>")<CR><CR>

nmap <C-c><C-s> :cs find s 
nmap <C-c><C-g> :cs find g 
nmap <C-c><C-c> :cs find c 
nmap <C-c><C-t> :cs find t 
nmap <C-c><C-e> :cs find e 
nmap <C-c><C-f> :cs find f 
nmap <C-c><C-i> :cs find i 
nmap <C-c><C-d> :cs find d 

