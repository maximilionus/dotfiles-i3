#!/usr/bin/env bash

set -e

SCREENSHOTS_PATH="$HOME/Pictures"

crop-to-clipboard() {
    tmp_bg="/tmp/screenshot-freeze-$(date +%s).png"

    grim \
        -l 0 \
        -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') \
        "$tmp_bg"
    imv -f $tmp_bg &
    sleep 0.01

    region=$(slurp || true)

    kill %%
    rm "$tmp_bg"

    [[ ! -n $region ]] && exit 1

    grim -g "$region" - | wl-copy
    notify-send --urgency low "Screenshot (Selection)" "Copied to clipboard"
}

fullscreen() {
    img_path="$SCREENSHOTS_PATH/screenshot-$(date +%Y%m%d-%H%M%S).png"

    grim \
        -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') \
        "$img_path"
    notify-send --urgency low "Screenshot (Fullscreen)" "Saved to $img_path"
}

case "$1" in
    crop-to-clipboard)
        crop-to-clipboard
        ;;
    *|fullscreen)
        fullscreen
        ;;
esac
