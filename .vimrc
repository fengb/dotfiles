syntax on
colors ir_black
filetype indent plugin on

set number

set tabstop=8
set shiftwidth=2
set softtabstop=2
set expandtab

set autoindent

set nobackup
set directory=~/.vim/tmp

set list
set listchars=tab:>-,trail:.

set colorcolumn=81
set hlsearch

set path=.,**
set wildmenu
set wildignore=**/node_modules/**

" window navigations
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

call plug#begin('~/.vim/plugged')
Plug 'https://github.com/kchmck/vim-coffee-script.git', { 'for': 'coffee' }
Plug 'https://github.com/elzr/vim-json.git', { 'for': 'json' }
Plug 'https://github.com/slim-template/vim-slim.git', { 'for': 'slim' }
Plug 'https://github.com/digitaltoad/vim-pug.git', { 'for': 'pug' }
Plug 'https://github.com/pangloss/vim-javascript.git', { 'for': 'javascript' }
Plug 'https://github.com/mxw/vim-jsx.git', { 'for': 'jsx' }
Plug 'https://github.com/elixir-lang/vim-elixir.git', { 'for': 'elixir', 'commit': '85593b118bae081538943640648e5d57f22f0aba' }
Plug 'https://github.com/rust-lang/rust.vim.git', { 'for': 'rust' }
Plug 'https://github.com/fatih/vim-go.git', { 'for': 'go' }
Plug 'https://github.com/leafgarland/typescript-vim', { 'for': 'typescript' }
call plug#end()
