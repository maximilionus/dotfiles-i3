#!/usr/bin/env bash

set -e

SCREENSHOTS_PATH="$HOME/Pictures"

crop-to-clipboard() {
    maim --select --hidecursor | xclip -selection clipboard -t image/png
    notify-send --urgency low "Screenshot (Selection)" "Copied to clipboard"
}

fullscreen() {
    img_path="$SCREENSHOTS_PATH/screenshot-$(date +%Y%m%d-%H%M%S).png"

    maim --hidecursor "$img_path"
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
