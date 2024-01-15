#!/bin/bash

print_metadata() {
    local icon="$1"
    local color="$2"
    local artist="$3"
    local title="$4"

    local metadata

    if [[ -n "$artist" && -n "$title" ]]; then
        metadata="%{F$color}$icon $artist - $title%{F-}"
    elif [[ -n "$artist" ]]; then
        metadata="%{F$color}$icon $artist%{F-}"
    elif [[ -n "$title" ]]; then
        metadata="%{F$color}$icon $title%{F-}"
    else
        metadata="%{F$color}$icon Unknown%{F-}"
    fi

    echo "$metadata"
}

# Check if playerctl is installed
if ! command -v playerctl &> /dev/null; then
    exit 1
fi

playerctl_status=$(playerctl status 2> /dev/null)

if [[ -z "$playerctl_status" || $playerctl_status == "Stopped" ]]; then
    echo ""
else
    artist=$(playerctl metadata --format "{{ artist }}")
    title=$(playerctl metadata --format "{{ title }}")

    if [[ $playerctl_status == "Playing" ]]; then
        print_metadata "󰐊" "#7366F8" "$artist" "$title"
    else
        print_metadata "󰏤" "#808080" "$artist" "$title"
    fi
fi
