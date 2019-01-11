#!/usr/bin/env sh

set -x
set -e # we must bail if we fail to `git crypt unlock`, etc

stow --no-folding -t $HOME/ homedir

if git ls-tree -r HEAD --name-only | sed 's/.*/"&"/' | xargs grep -qsPa "\x00GITCRYPT" ; then
  git crypt unlock
fi

stow --no-folding -t $HOME/ homedir-enc

# run init stuff here, detect if we should skip

