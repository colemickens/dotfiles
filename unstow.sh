#!/usr/bin/env sh

set -x
stow --delete --no-folding -t $HOME/ homedir
stow --delete --no-folding -t $HOME/ homedir-enc

