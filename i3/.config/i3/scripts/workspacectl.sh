#!/usr/bin/env bash

COMMAND="$1"
COMMAND_2="$2"
I3_STATE="${XDG_RUNTIME_DIR:-/tmp/$USER}/i3"
LAYER_FILE="$I3_STATE/workspace_layer"

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
        [[ ! -d "$I3_STATE" ]] && mkdir -p "$I3_STATE"
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
        i3-msg workspace number "$(get_workspace $COMMAND_2)"
        ;;
    move)
        i3-msg move container to workspace number "$(get_workspace $COMMAND_2)"
        ;;
    *)
        echo "Unknown command"
        ;;
esac
