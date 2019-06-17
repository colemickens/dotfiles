#!/usr/bin/env bash

set -x
set -euo pipefail

oldval="$(sudo rdmsr 0x1FC)"
newval="$(( 0xFFFFFFFE & 0x${oldval} ))"

sudo wrmsr -a 0x1FC "${newval}"

