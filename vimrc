let mapleader="\<SPACE>"

" Plugins {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:polyglot_disabled = ['markdown']
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline' " A nicer status line
Plug 'Raimondi/delimitMate' " Automatically close parantheses etc.
Plug 'majutsushi/tagbar' " Show tags in current file
Plug '~/dotfiles/modules/fzf' " Fuzzy finding
Plug 'junegunn/fzf.vim' " Fuzzy finding
Plug 'tpope/vim-fugitive' " Git commands
Plug 'luochen1990/rainbow' " Rainbow paranthesis
Plug 'sainnhe/sonokai' " Colorscheme
Plug 'Yggdroot/indentLine' " Show indentation markers
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
  Plug 'L3MON4D3/LuaSnip'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-path'
  "Plug 'npxbr/glow.nvim' " Markdown preview
  "Plug 'neovim/nvim-lspconfig'
  "Plug 'f-person/git-blame.nvim' " Show git blame at end of lines
else
  Plug 'sheerun/vim-polyglot' " Better syntax highlight
endif
"Plug 'garbas/vim-snipmate' " Autogenerate code
"Plug 'scrooloose/nerdtree' " A better file explorer
"Plug 'vim-syntastic/syntastic' " Syntax checker
"Plug 'Valloric/YouCompleteMe' " Always on autocomplete
"Plug 'docunext/closetag.vim' " Automatically close html tags
"Plug 'easymotion/vim-easymotion'
"Plug 'nbardiuk/vim-gol'
"Plug 'blueyed/vim-diminactive' " Dim inactive splits
"Plug 'ervandew/supertab' " Autocomplete with tab
"Plug 'szw/vim-tags' " Show all tags in file
call plug#end()

if has('nvim-0.5')
  lua <<EOF
  local function copy(args)
    return args[1]
  end
  -- Treesitter {{{
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
    },
    indent = {
      enable = true
    },
    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = false },
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },
  }
  -- }}}
  -- Telescope {{{
  require('telescope').setup{
    defaults = {
      file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
      grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
      qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    }
  }
  -- }}}
  -- nvim-cmp {{{
  local cmp = require'cmp'

  cmp.setup({
    mapping = {
      ['<C>n'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C>p'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C>q'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    snippet = {
      expand = function(args)
        require'luasnip'.lsp_expand(args.body)
      end
    },
    sources = cmp.config.sources(
    {
      {
        name = 'buffer',
        keyword_length = 3,
      },
      {
        name= 'luasnip',
        keyword_length = 2,
      },
    }),
    experimental = {
      ghost_text = true,
    },
  })


  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
      })
    })
  -- }}}
  -- LuaSnip {{{
  local ls = require("luasnip")
  local snip = ls.snippet
  local text = ls.text_node
  local insert = ls.insert_node
  local func = ls.function_node
  ls.snippets = {
    all = {
    },
    c = {
      snip("function",
        {
            insert(1, "void"),
            text(" "),
            insert(2, "name"),
            text("("),
            insert(3, "params"),
            text({ ")", "{", "  "}),
            insert(0),
            text({ "", "}" }),
        }
      ),
      snip("for",
        {
            text("for("),
            insert(1, "unsigned"),
            text(" "),
            insert(2, "i"),
            text(" = "),
            insert(3, "0"),
            text("; "),
            func(copy, 2),
            text(" "),
            insert(4, "<"),
            text(" "),
            insert(5),
            text("; "),
            insert(6),
            text("++"),
            func(copy, 2),
            text({") {", "  "}),
            insert(0),
            text({"", "}"}),
        }
      ),
      snip("if",
        {
            text("if("),
            insert(1),
            text({") {", "  "}),
            insert(0),
            text({"", "}"}),
        }
      ),
      snip("while",
        {
            text("while("),
            insert(1),
            text({") {", "  "}),
            insert(0),
            text({"", "}"}),
        }
      ),
      snip("do",
        {
            text({"do {", "  "}),
            insert(0),
            text({"", "} while("}),
            insert(1),
            text(");"),
        }
      ),
      snip("cscript",
        {
          text({"#!/bin/bash", "tail -n +3 $0 | gcc -std=c17 -Wall -Werror -O3 -x c - && exec ./a.out"}),
        }
      )
    },
    cpp = {
      snip("cscript",
        {
          text({"#!/bin/bash", "tail -n +3 $0 | g++ -std=c++17 -Wall -Werror -O3 -x c++ - && exec ./a.out"}),
        }
      )
    },
  }
  ls.filetype_extend("cpp", { "c" })
  -- }}}
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=20

noremap <Leader>p <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>q <cmd>Telescope quickfix<cr>
nnoremap <leader>t <cmd>Telescope treesitter<cr>

imap <silent><expr> <Esc>n luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : ''
inoremap <silent> <Esc>p <cmd>lua require'luasnip'.jump(-1)<Cr>
snoremap <silent> <Esc>n <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <Esc>p <cmd>lua require('luasnip').jump(-1)<Cr>
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
endif
" cscope settings {{{

set cscopetag
set csprg=gtags-cscope
if !empty(expand(glob("GTAGS")))
  cs add GTAGS
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
nnoremap <leader>evv :vsplit ~/dotfiles/vimrc<cr>
" source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
" surround word with "
:nnoremap <space>" ea"<esc>bi"<esc>

nnoremap <M-m> :Man <C-R>=expand("<cword>")<CR><CR>

if has('nvim')
  " For moving in wrapped text
  noremap <A-k> gk
  noremap <A-j> gj
  " Execute current file
  noremap <A-r> :!./%<CR>
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

" Statusline
"set laststatus=2
"set statusline=%<%F\ %h%m%r%y%=%-14.(%l,%c%V%)\ %P

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

augroup shell_rc
  autocmd!
  autocmd BufRead *shrc setlocal foldmethod=marker
  autocmd BufRead *shrc setlocal foldlevel=0
augroup END
" }}}

" Autocorrections {{{
ab pritnf printf

" }}}
