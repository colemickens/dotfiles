#!/usr/bin/env sh

set -x
set -e # we must bail if we fail to `git crypt unlock`, etc

stow --no-folding -t $HOME/ homedir

git crypt unlock
stow --no-folding -t $HOME/ homedir-enc

# run init stuff here, detect if we should skip

