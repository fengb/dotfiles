syntax on
colors ir_black
filetype indent plugin on

set number

set tabstop=8
set shiftwidth=2
set softtabstop=2
set expandtab
set nofoldenable

set autoindent
set nocindent
set nosmartindent
set indentkeys=

set nobackup
set directory=~/.vimtmp

set list
set listchars=tab:>-,trail:.

set hlsearch

set path=.,**
set wildmenu
set wildignore=**/node_modules/**
set mouse=

" window navigations
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

call plug#begin('~/.vim/plugged')
Plug 'https://github.com/slim-template/vim-slim.git', { 'for': 'slim' }
Plug 'https://github.com/digitaltoad/vim-pug.git', { 'for': 'pug' }
Plug 'https://github.com/pangloss/vim-javascript.git', { 'for': 'javascript' }
Plug 'https://github.com/rust-lang/rust.vim.git', { 'for': 'rust' }
Plug 'https://github.com/fatih/vim-go.git', { 'for': 'go' }
Plug 'https://github.com/leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'https://github.com/sbdchd/neoformat'
Plug 'https://github.com/ahw/vim-pbcopy'
Plug 'https://github.com/ziglang/zig.vim', { 'for': 'zig' }
Plug 'https://github.com/joukevandermaas/vim-ember-hbs', { 'for': 'hbs' }
call plug#end()

map <C-i> :Neoformat<CR>
let g:neoformat_enabled_javascript = ['prettiereslint', 'prettier']
let g:vim_json_conceal=0
