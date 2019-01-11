#!/usr/bin/env bash

[ -f ~/.idle-inhibit ] && echo "LOCK off"
[ -f ~/.idle-inhibit ] || echo "LOCK on"

