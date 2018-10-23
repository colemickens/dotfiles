#!/usr/bin/env bash

[ -f ~/.idle-inhibit ] && echo "IDLE: [INHIBITED]"
[ -f ~/.idle-inhibit ] || echo "IDLE: [off]"

