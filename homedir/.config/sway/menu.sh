#!/usr/bin/env bash

if [[ "$1" == "x11" ]]; then
  set -- "env GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb"
fi

compgen -c \
  | sort -u \
  | fzf --no-extended --print-query \
  | tail -n1 \
  | xargs -r swaymsg -t command exec "${@}"

