export XDG_CURRENT_DESKTOP=i3
export X11_SCREENLOCK_TIMEOUT="300" # Timeout in seconds before the automatic
                                    # screenlock
export I3_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/i3"
export I3_SCRIPTS_DIR="$I3_CONFIG_DIR/scripts"
export I3_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/var/run/user/$UID}/i3"
