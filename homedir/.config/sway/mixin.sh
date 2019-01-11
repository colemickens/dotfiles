#!/usr/bin/env bash
set -x

DIR="${HOME}/.config/sway"

set -u
mixindir="${DIR}/config.${1}.d"
target="${DIR}/${2}.conf"
linkname="${mixindir}/${2}.conf"
rm -rf "${mixindir}"
mkdir -p "${mixindir}"
ln -s "${target}" "${linkname}"

