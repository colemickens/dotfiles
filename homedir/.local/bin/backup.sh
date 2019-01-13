#!/usr/bin/env bash

set -x

BACKUP="/tmp/foo/XEEP"

src="${HOME}/"
dst="/tmp/foo/XEEP/HOME_COLE"

rsync \
  -avh \
  --delete \
  --exclude=".cache" \
  --exclude=".config/pulse" \
  --exclude=".mozilla/firefox" \
  --exclude=".local/share/nvim/swap" \
  --exclude="target/release" \
  --exclude="target/debug" \
  --delete-excluded \
  "${src}" "${dst}"

