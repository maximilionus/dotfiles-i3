#!/usr/bin/env bash

COMMAND="$1"
COMMAND_2="$2"
SWAY_STATE="${XDG_RUNTIME_DIR:-/tmp/$USER}/sway"
LAYER_FILE="$SWAY_STATE/workspace_layer"

get_layer () {
    head -1 "$LAYER_FILE" 2>/dev/null || echo ""
}

get_workspace () {
    number="$1"
    echo "$(get_layer)$number"
}

case "$COMMAND" in
    get-layer)
        get_layer
        ;;
    set-layer)
        notify="Workspace layer"
        [[ ! -d "$SWAY_STATE" ]] && mkdir -p "$SWAY_STATE"
        if [[ "$COMMAND_2" == 0 ]]; then
            COMMAND_2=""
            notify="$notify unset"
        else
            notify="$notify set to $COMMAND_2"
        fi
        echo "$COMMAND_2" > "$LAYER_FILE"
        notify-send --urgency low --expire-time 500 "$notify"
        ;;
    set)
        swaymsg workspace number "$(get_workspace $COMMAND_2)"
        ;;
    move)
        swaymsg move container to workspace number "$(get_workspace $COMMAND_2)"
        ;;
    *)
        echo "Unknown command"
        ;;
esac
