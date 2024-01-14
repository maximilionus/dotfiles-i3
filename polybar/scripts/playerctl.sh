#!/bin/bash


# Stop the exec if 'playerctl' is not detected
if ! command -v playerctl &> /dev/null; then
    exit 1
fi

playerctl_status=$(playerctl status 2> /dev/null)

if [[ -z "$playerctl_status" ]]; then
    echo ""
elif [[ "$playerctl_status" == "Playing" ]]; then
    metadata=$(playerctl metadata --format "󰐊 {{ artist }} - {{ title }}")
    echo "%{F#7366F8}$metadata%{F-}"
else
    metadata=$(playerctl metadata --format "󰏤 {{ artist }} - {{ title }}")
    echo "%{F#808080}$metadata%{F-}"
fi
