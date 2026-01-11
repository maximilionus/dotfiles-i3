#!/usr/bin/env bash
#
# Launch the idle timeout

TIMEOUT="300" # Seconds until locked

SCRIPT_DIR="$(dirname $(realpath $0))"
SWAY_STATE="${XDG_RUNTIME_DIR:-/tmp/$USER}/sway"
SWAY_SCRIPT_LOCKER="$SCRIPT_DIR/screenlock.sh"
PID_FILE="$SWAY_STATE/swayidle.pid"

swayidle timeout "$TIMEOUT" "sh $SWAY_SCRIPT_LOCKER" &
echo $! > "$PID_FILE"
