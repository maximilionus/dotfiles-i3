#!/bin/bash

# Check if playerctl is installed
if ! command -v playerctl &> /dev/null; then
    exit 1
fi

module_mode=0

switch_mode() {
    case "$module_mode" in
        0) module_mode=1 ;;
        1) module_mode=0 ;;
    esac
}

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

while true; do
    playerctl_status=$(playerctl status 2> /dev/null)
    trap "switch_mode" USR1  # Detect if simplified mode requested by user

    if [[ -z "$playerctl_status" || $playerctl_status == "Stopped" ]]; then
        echo ""
    else
        if [[ module_mode -eq 0 ]]; then
            artist=$(playerctl metadata --format "{{ artist }}")
            title=$(playerctl metadata --format "{{ title }}")
        else
            artist=""
            title="Playback"
        fi

        if [[ $playerctl_status == "Playing" ]]; then
            print_metadata "󰐊" "#7366F8" "$artist" "$title"
        else
            print_metadata "󰏤" "#808080" "$artist" "$title"
        fi
    fi

    sleep 1
done
