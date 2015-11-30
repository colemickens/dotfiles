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
Plug 'trusktr/seti.vim'

Plug 'bling/vim-airline'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/syntastic'
"Plug 'universal-ctags/ctags'
"Plug 'rentalcustard/exuberant-ctags'
Plug 'Valloric/YouCompleteMe'

Plug 'majutsushi/tagbar'
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'

Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

call plug#end()

set background=dark
colors colorsbox-stnight
set background=dark

" airline options
let g:airline_powerline_fonts = 1

" show relative line numbers
set rnu

" ? 
set shiftwidth=4
set tabstop=4

" show tabs
set list

" default omnifunc setting
set omnifunc=syntaxcomplete#Complete

" rust.vim options
let g:rustfmt_autosave = 1

" Syntastic options
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

