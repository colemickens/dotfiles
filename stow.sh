#!/usr/bin/env sh

set -x
stow --no-folding -t $HOME/ homedir
stow --no-folding -t $HOME/ homedir-enc

