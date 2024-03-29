#!/bin/bash

# Check if playerctl is installed and freeze the execution if command is not
# available
if ! command -v playerctl &> /dev/null; then
    read
fi

# Variables
COLOR_ACTIVE="#7366F8"
COLOR_INACTIVE="#808080"

# Default module mode set here.
# 0 - Full output
# 1 - Simplified output, no metadata
module_mode=0

# Define the max length of the output characters,
# output gets truncated if exceeds the limit.
module_output_max_length=50

# Module refresh delay in seconds
module_refresh_delay=1

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
        metadata="$artist - $title"
    elif [[ -n "$artist" ]]; then
        metadata="$artist"
    elif [[ -n "$title" ]]; then
        metadata="$title"
    else
        metadata="Unknown"
    fi

    if [[ ${#metadata} -gt $module_output_max_length ]]; then
        metadata="${metadata:0:$module_output_max_length}..."
    fi

    echo "%{F$color}$icon $metadata%{F-}"
}

while true; do
    playerctl_status=$(playerctl status 2> /dev/null)

    # Detect if simplified mode requested by user
    trap "switch_mode" USR1

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
            print_metadata "󰐊" "$COLOR_ACTIVE" "$artist" "$title"
        else
            print_metadata "󰏤" "$COLOR_INACTIVE" "$artist" "$title"
        fi
    fi

    sleep $module_refresh_delay
done
