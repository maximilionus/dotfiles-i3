#!/usr/bin/env bash
#
# Immediately launch the lockscreen, turning off the display after the timeout

DISPLAY_TIMEOUT="${1:-10}"

swayidle \
    timeout $DISPLAY_TIMEOUT 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' &

swaylock

kill %%
