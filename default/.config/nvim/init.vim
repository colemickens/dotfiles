filetype plugin on

call plug#begin('~/.nvim/plugged')

Plug 'tomasr/molokai'
Plug 'mkarmona/colorsbox'
Plug 'geoffharcourt/one-dark.vim'
Plug 'DrSpatula/vim-buddy'
Plug 'bling/vim-airline'
Plug 'sickill/vim-monokai'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }

call plug#end()

set background=dark
colors buddy
set rnu

set shiftwidth=4
set tabstop=4

let g:airline_powerline_fonts = 1
