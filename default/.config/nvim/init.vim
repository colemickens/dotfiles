filetype plugin on

call plug#begin('~/.config/nvim/plugged')

Plug 'bling/vim-airline'

Plug 'mkarmona/colorsbox'
Plug 'morhetz/gruvbox'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/syntastic'
"Plug 'universal-ctags/ctags'
Plug 'rentalcustard/exuberant-ctags'
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-fugitive'

Plug 'majutsushi/tagbar'
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'

Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

call plug#end()

let g:gruvbox_italic=1
let g:colorsbox_italic=1
set background=dark
colors colorsbox-stnight
"colors gruvbox
set background=dark

" airline options
let g:airline_powerline_fonts = 1

" show relative line numbers
set rnu
set nu

" ? 
set shiftwidth=4
set tabstop=4

" show tabs
set list

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" FZF
map <C-p> :FZF<CR>

" default omnifunc setting
set omnifunc=syntaxcomplete#Complete

" rust.vim options
let g:rustfmt_autosave = 1

" vim-go options
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

" Syntastic options
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

