#!/usr/bin/env bash
#
# Immediately launch the lockscreen, turning off the display after the timeout

set -e

xset +dpms dpms 10 10 10
i3lock --nofork --show-keyboard-layout --show-failed-attempts \
       --ignore-empty-password \
       --image="$HOME/Pictures/wallpaper" --color "#181818"
xset dpms \
    "$X11_SCREENLOCK_TIMEOUT" "$X11_SCREENLOCK_TIMEOUT" "$X11_SCREENLOCK_TIMEOUT"
