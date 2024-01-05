#!/bin/bash

set -e

echo "-> Installing the i3 configurations set."

sources=("i3" "picom" "polybar" "rofi" "dunst")
targets=("$HOME/.config" "$HOME/.config" "$HOME/.config" "$HOME/.config" "$HOME/.config")

for ((i=0; i<${#targets[@]}; i++)); do
    target="${targets[i]}"
    source="${sources[i]}"

    echo "--> Installing configuration for \"$source\"."
    ln -sf "$(realpath "$source")" "$target"
done

echo "-> i3 configuration set successfully installed,"
echo "   restart your shell to load the changes."
