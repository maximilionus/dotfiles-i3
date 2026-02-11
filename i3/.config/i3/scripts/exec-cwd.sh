#!/usr/bin/env bash
#
# Execute the specified command in the current working directory of the active
# X11 window.

window_xid=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)
window_pid=$(xprop -id "$window_xid" _NET_WM_PID | grep -oP "\d+")
child_pid=$(pgrep -P "$window_pid" | tail -n 1)

if [[ -n "$child_pid" ]]; then
    cwd=$(readlink -f "/proc/$child_pid/cwd")
    cd "$cwd"
fi

exec "$@"
