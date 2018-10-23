#!/usr/bin/env bash

export WLR_DRM_NO_ATOMIC=1
pkill redshift
redshift -m wayland -l 47.6062:-122.3321 -v

