if &compatible
  set nocompatible
endif

"""""""""""""""""""
" dein
"""""""""""""""""""
set runtimepath^=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.config/nvim/dein/repos/github.com/Shougo/dein.vim'))

call dein#add('Shougo/dein.vim')

" Statusbar bling
call dein#add('bling/vim-airline')

" Colorschemes
call dein#add('morhetz/gruvbox')
call dein#add('mkarmona/materialbox')
call dein#add('DrSpatula/vim-buddy')
call dein#add('djjcast/mirodark')
call dein#add('notpratheek/vim-luna')

" File Management
call dein#add('scrooloose/nerdtree', { 'on_cmd':  'NERDTreeToggle' })
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/vimfiler.vim')
call dein#add('junegunn/fzf', { 'build': './install', 'rtp': '' })

" Git Plugins
call dein#add('Xuyuanp/nerdtree-git-plugin')
call dein#add('tpope/vim-fugitive')
call dein#add('airblade/vim-gitgutter')

" Syntax completion/checking
call dein#add('Shougo/deoplete.nvim')
call dein#add('Shougo/neocomplete.vim')
call dein#add('majutsushi/tagbar')
call dein#add('PProvost/vim-ps1')

" Language specific
call dein#add('fatih/vim-go')
call dein#add('rust-lang/rust.vim')
call dein#add('LnL7/vim-nix')

call dein#end()

"""""""""""""""""
" NeoVim Config "
"""""""""""""""""
"filetype plugin on
filetype plugin indent on

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" show relative line numbers above and below absolute line number
set rnu
set nu

" tab configuration (?)
set shiftwidth=4
set tabstop=4

" show tabs
set list

" colorscheme/appearance
colors gruvbox
"colors buddy
set background=dark

" gruvbox options
let g:gruvbox_italic=1




" bling/vim-airline options
let g:airline_powerline_fonts = 0

" scrooloose/nerdtree options
map <C-n> :NERDTreeToggle<CR>

" junegunn/fzf options
map <C-p> :FZF<CR>

" rust-lang/rust.vim options
" let g:rustfmt_autosave = 1

" Shougo/deoplete.nvim options
let g:deoplete#enable_at_startup = 1



" DISABLE YAML for now
autocmd FileType yaml let b:did_indent = 1

au BufReadPost Jenkinsfile* set syntax=groovy




"let g:terminal_color_0  = '#2e3436'
"let g:terminal_color_1  = '#cc0000'
"let g:terminal_color_2  = '#4e9a06'
"let g:terminal_color_3  = '#c4a000'
"let g:terminal_color_4  = '#3465a4'
"let g:terminal_color_5  = '#75507b'
"let g:terminal_color_6  = '#0b939b'
"let g:terminal_color_7  = '#d3d7cf'
"let g:terminal_color_8  = '#555753'
"let g:terminal_color_9  = '#ef2929'
"let g:terminal_color_10 = '#8ae234'
"let g:terminal_color_11 = '#fce94f'
"let g:terminal_color_12 = '#729fcf'
"let g:terminal_color_13 = '#ad7fa8'
"let g:terminal_color_14 = '#00f5e9'
"let g:terminal_color_15 = '#eeeeec'

highlight Normal ctermbg=none

au BufReadPost Jenkinsfile.* set syntax=groovy
