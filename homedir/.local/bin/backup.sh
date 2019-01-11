#!/usr/bin/env bash

set -x

BACKUP="/tmp/foo/XEEP"

src="${HOME}/"
dst="/tmp/foo/XEEP/HOME_COLE"

rsync \
  -avh \
  --delete \
  --exclude=".cache" \
  --exclude="target/release" \
  --exclude="target/debug" \
  --delete-excluded \
  "${src}" "${dst}"

