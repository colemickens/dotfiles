#!/usr/bin/env bash

set -x

BACKUP="/tmp/foo/XEEP"

src="${HOME}/"
dst="/tmp/foo/XEEP/HOME_COLE"

rsync \
  -avh \
  --delete \
  --exclude=".cache" \
  --delete-excluded \
  "${src}" "${dst}"

