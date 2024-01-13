#!/bin/bash

set -e

echo "-> Installing the tools configuration:"

sources=("i3" "picom" "polybar" "rofi" "dunst")
targets=("$HOME/.config" "$HOME/.config" "$HOME/.config" "$HOME/.config" "$HOME/.config")

for ((i=0; i<${#targets[@]}; i++)); do
    target="${targets[i]}"
    source="${sources[i]}"

    echo "==> Configuration for \"$source\":"
    cp -rfv $(realpath "$source") "$target"
done

echo "-> Installing the font configuration:"
fonts_source=./fontconfig
fonts_target=~/.config/fontconfig/conf.d

mkdir -pv $fonts_target
cp -rvf $fonts_source/* $fonts_target/

echo "-> i3 configuration set successfully installed,"
echo "   restart your shell to load the changes."
