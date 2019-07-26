#!/usr/bin/env bash
set -euo pipefail
set -x

declare -A timezones=(
  ["SEA"]=":US/Pacific"
  ["TOP"]=":US/Central"
  ["SWZ"]=":Europe/Zurich"
)

result=""
for K in "${!timezones[@]}"; do
  time="$(env TZ="${timezones["$K"]}" date '+%H:%M:%S')"
  result="${result}${K}/${time} "
done

result="${result%" "}"
printf "%s" "${result}"

