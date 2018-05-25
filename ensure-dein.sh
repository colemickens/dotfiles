#!/usr/bin/env bash

DEIN_HOME="$HOME/.local/share/nvim/dein/repos/github.com/Shougo/dein.vim"
[[ -d "${DEIN_HOME}" ]] || {
  mkdir -p "${DEIN_HOME}"
  git clone https://github.com/Shougo/dein.vim "${DEIN_HOME}"
}

VIMINSTALL=y nvim

