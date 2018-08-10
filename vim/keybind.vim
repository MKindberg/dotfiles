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

set pastetoggle=<F12>
map <F5> :e <CR>
map <F2> :NERDTreeToggle <CR>
map <F3> :TagbarToggle<CR>
map <C-L> :set relativenumber! <CR>
map <S-H> :set cursorline! <CR>
map <C-P> :FZF <CR>

map <Space>h :set cursorline! <CR>
map <Space>rn :set relativenumber! <CR>
map <Space>n :set number! <CR>
map <Space>l :call ToggleH() <CR>
map <Space>s :if exists("g:syntax_on") <Bar>
            \ syntax off <Bar>  
            \ else <Bar>
            \ syntax enable <Bar>
            \ endif <CR>

" Cscope bindings
nmap <C-c>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-c>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-c>d :cs find d <C-R>=expand("<cword>")<CR><CR>

nmap <C-c><C-c>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-c>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-c>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-c>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-c>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-c>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-c><C-c>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-c><C-c>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
nmap <C-c>h :cs help <CR>

nmap <C-c><C-s> :cs find s 
nmap <C-c><C-g> :cs find g 
nmap <C-c><C-c> :cs find c 
nmap <C-c><C-t> :cs find t 
nmap <C-c><C-e> :cs find e 
nmap <C-c><C-f> :cs find f 
nmap <C-c><C-i> :cs find i 
nmap <C-c><C-d> :cs find d 

