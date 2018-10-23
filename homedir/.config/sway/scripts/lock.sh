#!/usr/bin/env bash

function s() {
  swaylock \
    --indicator-radius 300 \
    --indicator-thickness 20 \
    --ring-color 333333 \
    --key-hl-color FFFFFF \
    --bs-hl-color 000000 \
    --text-color FFFFFF00 \
    "${@}"
}

s -i ~/.wallpaper/corruption.jpg

