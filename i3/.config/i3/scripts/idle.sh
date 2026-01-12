#!/usr/bin/env bash
#
# Launch the idle timeout

TIMEOUT="300" # Seconds until locked

SCRIPT_DIR="$(dirname $(realpath $0))"
I3_STATE="${XDG_RUNTIME_DIR:-/tmp/$USER}/i3"
I3_SCRIPT_LOCKER="$SCRIPT_DIR/screenlock.sh"
PID_FILE="$I3_STATE/swayidle.pid"

swayidle timeout "$TIMEOUT" "sh $I3_SCRIPT_LOCKER" &
echo $! > "$PID_FILE"
