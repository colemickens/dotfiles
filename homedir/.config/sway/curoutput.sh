#!/usr/bin/env bash
set -euo pipefail

direction=$1; shift

curoutput="$(swaymsg -t get_outputs | jq '.[] | select(.focused == true)')"
oldvalraw="$(echo "${curoutput}" | jq '.scale')"
name="$(echo "${curoutput}" | jq '.name')"

# round value
printf -v oldval "%.1f" "${oldvalraw}"

if [[ "${direction}" == "up" ]]; then
  args=("scale" "$(echo "${oldval} + .1" | bc)")
elif [[ "${direction}" == "down" ]]; then
  args=("scale" "$(echo "${oldval} - .1" | bc)")
elif [[ "${direction}" == "off" ]]; then
  args=("disable")
fi

swaymsg output "${name}" "${args[@]}"
