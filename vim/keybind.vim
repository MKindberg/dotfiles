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

let mapleader="\<SPACE>"

map :Q :q
map :W :w
map :WQ :wq

set pastetoggle=<F12>
map <F5> :e <CR>
map <F4> :RainbowToggle <CR>
map <F2> :NERDTreeToggle <CR>
map <F3> :TagbarToggle<CR>
map <C-L> :set relativenumber! <CR>
map <S-H> :set cursorline! <CR>
map <C-P> :FZF <CR>
map & :Lines <CR>
map ¤ $

map <Leader>h :hi CursorLine cterm=bold ctermbg=black <CR>
            \:set cursorline! <CR>
map <Leader>rn :set relativenumber! <CR>
map <Leader>n :set number! <CR>
map <Leader>l :call ToggleH() <CR>
map <Leader>s :if exists("g:syntax_on") <Bar>
            \ syntax off <Bar>  
            \ else <Bar>
            \ syntax enable <Bar>
            \ endif <CR>
            \ :hi CursorLine cterm=bold ctermbg=black <CR>
map <Leader>t :terminal<CR>
map <Leader><Leader> za
" open vimrc in new split
nnoremap <leader>ev :vsplit $MYVIMRC<cr> 
" source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
" surround word with "
:nnoremap <space>" ea"<esc>bi"<esc>


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

nmap <M-m> :Man <C-R>=expand("<cword>")<CR><CR>

if has('nvim')
  " For moving in wrapped text
  map <A-k> gk
  map <A-j> gj
  " Execute current file
  map <A-r> :!./%<CR>
else
  map <Esc>k gk
  map <Esc>j gj
  map <Esc>r :!./%<CR>
endif

let g:EasyMotion_do_mapping = 0
nmap <Space>f <Plug>(easymotion-overwin-f)
nmap <Space>w <Plug>(easymotion-overwin-w)

imap jj <Esc>
" Make word uppercase
:imap <c-u> <esc>viwUi

" Save as root even when file wasn't open with sudo
cmap w!! w !sudo tee > /dev/null %
