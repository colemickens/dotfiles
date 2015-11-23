filetype plugin on

call plug#begin('~/.nvim/plugged')

Plug 'tomasr/molokai'
Plug 'mkarmona/colorsbox'
Plug 'mkarmona/materialbox'
Plug 'morhetz/gruvbox'
Plug 'geoffharcourt/one-dark.vim'
Plug 'DrSpatula/vim-buddy'
Plug 'sickill/vim-monokai'
Plug 'jscappini/material.vim'

Plug 'bling/vim-airline'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }

call plug#end()

set background=dark
colors buddy
colors colorsbox-stnight
colors material
set background=dark

set rnu

set shiftwidth=4
set tabstop=4

let g:airline_powerline_fonts = 1

