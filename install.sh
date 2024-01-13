#!/bin/bash

set -e

echo "-> Installing the configurations:"
packages=("i3" "picom" "polybar" "rofi" "dunst")
cp -rfv --target-directory=$HOME/.config "${packages[@]}"

echo "-> Installing the font configuration:"
fonts_source=./fontconfig
fonts_target=~/.config/fontconfig/conf.d
mkdir -pv $fonts_target
cp -rvf $fonts_source/* $fonts_target/

echo "-> i3 configuration set successfully installed,"
echo "   restart your shell to load the changes."
