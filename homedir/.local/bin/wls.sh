#!/usr/bin/env bash

speedMbits="6000k"
log="/tmp/wlstream.log"
hwtype="vaapi"

if [[ "${1:-}" == "" ]]; then
  echo "must specify an output" >&2
  wlstream
  exit -1
fi

output="${1}"
shift

if [[ "${1:-}" == "youtube" ]]; then
  format="flv"
  url="rtmp://a.rtmp.youtube.com/live2/$(cat $HOME/.secrets/youtube-streamkey)"
elif [[ "${1:-}" == "twitch" ]]; then
  format="flv"
  url="rtmp://live-sea.twitch.tv/app/$(cat $HOME/.secrets/twitch-streamkey)"
elif [[ "${1:-}" == "" ]]; then
  echo "must provide a filename or stream target" >&2
  exit -1
else
  format="matroska"
  url="${1}"
fi

trap EXIT 'pkill wls && exit 0'

while true; do
  wlstream \
    "${output}" \
    "${hwtype}" \
    "/dev/dri/renderD128" \
    "libx264" \
    "nv12" \
    "${speedMbits}" \
    "${url}" \
    #"${format}"

  [[ "${format}" == "matroska" ]] && break
  break

  sleep 1
done

