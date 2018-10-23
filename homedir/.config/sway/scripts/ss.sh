#!/usr/bin/env bash

f="${HOME}/screenshot-$(date '+%s').png"

if [[ "${1:-}" == "--region" ]]; then
  grim -g "$(slurp)" "${f}"
else
  grim "${f}"
fi

