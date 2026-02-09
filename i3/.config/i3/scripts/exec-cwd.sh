#!/bin/bash
#
# Execute any provided command in the current working directory of the focused
# i3 window.

cwd=""
window_id=$(i3-msg -t get_tree | jq '.. | objects | select(.focused==true) | .window')
window_pid=$(xprop -id $window_id | grep _NET_WM_PID | grep -oP "\d+")
child_pid=$(pgrep -P $window_pid | tail -n 1)

if [[ ! -z "$child_pid" ]]; then
    cwd=$(readlink -f "/proc/$child_pid/cwd")
    cd "$cwd"
fi

exec "$@"
