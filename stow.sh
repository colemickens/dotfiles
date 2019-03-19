#!/usr/bin/env sh

set -x
set -e # we must bail if we fail to `git crypt unlock`, etc


if git ls-tree -r HEAD --name-only | sed 's/.*/"&"/' | xargs grep -qsPa "\x00GITCRYPT" ; then
  git crypt unlock
fi

#if [[ ! -f /etc/NIXOS ]]; then
#  echo "you're in non-nixos, not stowing"
  stow --no-folding -t $HOME/ homedir
#else
#  echo "you're in nixos, not stowing"
#fi

