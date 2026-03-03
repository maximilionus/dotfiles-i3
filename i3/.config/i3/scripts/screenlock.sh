#!/usr/bin/env bash
#
# Immediately launch the lockscreen, turning off the display after the timeout

set -e

screen_res="$(xdpyinfo | grep dimensions | cut -d' ' -f7)"

xset +dpms dpms 10 10 10
magick convert -gravity Center -resize "$screen_res"^ "$HOME/Pictures/wallpaper" RGB:- | \
    i3lock --nofork --show-keyboard-layout --show-failed-attempts --ignore-empty-password \
        --raw "$screen_res":rgb --image=/dev/stdin --color "#181818"
xset dpms \
    "$X11_SCREENLOCK_TIMEOUT" "$X11_SCREENLOCK_TIMEOUT" "$X11_SCREENLOCK_TIMEOUT"
