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

" window navigations
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

call plug#begin('~/.vim/plugged')
Plug 'https://github.com/kchmck/vim-coffee-script.git'
Plug 'https://github.com/elzr/vim-json.git'
Plug 'https://github.com/slim-template/vim-slim.git'
Plug 'https://github.com/digitaltoad/vim-pug.git'
Plug 'https://github.com/pangloss/vim-javascript.git'
Plug 'https://github.com/mxw/vim-jsx.git'
Plug 'https://github.com/elixir-lang/vim-elixir.git', { 'commit': '85593b118bae081538943640648e5d57f22f0aba' }
call plug#end()
