set nocompatible
set runtimepath=~/.nvim/
filetype off

set rtp+=~/.nvim/bundle/Vundle.vim

call vundle#rc('~/.nvim/bundle')

call vundle#begin()

Plugin 'gmarik/vundle'
Plugin 'FuzzyFinder'
Plugin 'L9'
Plugin 'OmniSharp/omnisharp-vim'

call vundle#end()

set nu
syn on

filetype plugin indent on

