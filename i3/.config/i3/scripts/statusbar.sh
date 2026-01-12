#!/usr/bin/env bash

# Do not update the status bar when the screen is locked.
if pgrep -x i3lock > /dev/null; then exit 0; fi

SPLITTER=
# SPLITTER="<span foreground=\"gray\">|</span>"

KB_PREFIX="LANG "
VOLUME_PREFIX="VOL "
BATTERY_PREFIX="BAT "
BACKLIGHT_PREFIX="B "
NET_PREFIX="NET"
NET_LAN="Eth"
NET_WIFI="WiFi"
NET_BRIDGE="Bridge"
NET_TUN="Tunnel"
NET_DOWN="Offline"
BLUETOOTH_PREFIX="BT"
BLUETOOTH_CONNECTED="Con"
NOTIFICATIONS_PREFIX="NOTIF"
NOTIFICATIONS_MUTED="Silent"
WAKELOCK_PREFIX="WAKE"
WAKELOCK_ACTIVE="Lock"

# Date
date_module=$(date +'%e %a %H:%M')

# Keyboard
keyboard_module="$KB_PREFIX"
keyboard_module_fnc() {
    keyboard_module="${keyboard_module}$(i3-msg -t get_inputs \
        | jq -r '.[] | select(.type=="keyboard") | .xkb_active_layout_name' \
        | head -n1 \
        | cut -d' ' -f1 \
        | cut -c1-2)"
}
#keyboard_module_fnc

# Audio
audio_module=""
audio_module_fnc() {
    local vol mute
    vol=$(pactl get-sink-volume "@DEFAULT_SINK@" | awk -F'/' 'NR==1 {gsub(/ /,"",$2); print $2}')
    mute=$(pactl get-sink-mute "@DEFAULT_SINK@" | awk '{print $2}')

    if [ "$mute" = "yes" ]; then
        audio_module="$VOLUME_PREFIX Muted"
    else
        audio_module="$VOLUME_PREFIX $vol"
    fi
}
audio_module_fnc

# Battery
battery_module=""
battery_module_fnc() {
    local battery_status=$(ls /sys/class/power_supply/ | grep BAT | head -n1)

    if [[ -z $battery_status ]]; then
        return 0
    fi

    local capacity=$(cat /sys/class/power_supply/$battery_status/capacity)
    local status=$(cat /sys/class/power_supply/$battery_status/status)

    if [[ $status = "Charging" ]]; then
        icon="+"
    fi

    battery_module="$BATTERY_PREFIX$icon $capacity%"
}
battery_module_fnc

# Screen backlight
backlight_module=""
backlight_module_fnc() {
    backlight_dir="/sys/class/backlight"
    device=$(ls "$backlight_dir" 2>/dev/null | head -n1)

    if [[ -n "$device" ]]; then
        max_brightness=$(cat "$backlight_dir/$device/max_brightness")
        cur_brightness=$(cat "$backlight_dir/$device/brightness")
        percent=$(( cur_brightness * 100 / max_brightness ))
        backlight_module="$BACKLIGHT_PREFIX  $percent%"
    fi
}
backlight_module_fnc

# Network
network_module="$NET_PREFIX $NET_DOWN"
network_module_fnc() {
    default_iface=$(ip route 2>/dev/null | awk '/^default/ {print $5; exit}')

    if [[ -n "$default_iface" ]]; then
        if [[ -d "/sys/class/net/$default_iface/device" ]]; then
            if [[ $default_iface == wl* ]]; then
                network_module="$NET_PREFIX $NET_WIFI"
            else
                network_module="$NET_PREFIX $NET_LAN"
            fi
        elif [[ -d "/sys/class/net/$default_iface/bridge" ]]; then
            network_module="$NET_PREFIX $NET_BRIDGE"
        elif [[ -e "/sys/class/net/$default_iface/tun_flags" ]]; then
            network_module="$NET_PREFIX $NET_TUN"
        else
            network_module="$NET_PREFIX Unknown"
        fi
    fi
}
network_module_fnc

# Bluetooth
bluetooth_module=""
bluetooth_module_fnc() {
    if ! systemctl is-active --quiet bluetooth.service; then
        return 0
    fi

    bluetooth_power=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
    [[ "$bluetooth_power" = "no" ]] && return 0

    local connected=$(bluetoothctl info | grep "Connected: yes")
    if [ -n "$connected" ]; then
        bluetooth_module="${BLUETOOTH_PREFIX} ${BLUETOOTH_CONNECTED}"
    else
        bluetooth_module="$BLUETOOTH_PREFIX"
    fi
}
bluetooth_module_fnc

# Notifications
notifications_module=""
notifications_module_fnc() {
    if ! pidof dunst > /dev/null; then
        return 0;
    fi

    paused=$(dunstctl is-paused)
    count=$(dunstctl count waiting)

    if [ "$paused" == "false" ]; then
        : #notifications_module="$NOTIFICATIONS_PREFIX"
    else
        if [ "$count" != "0" ]; then
            notifications_module="$NOTIFICATIONS_PREFIX $NOTIFICATIONS_MUTED ($count)"
        else
            notifications_module="$NOTIFICATIONS_PREFIX $NOTIFICATIONS_MUTED"
        fi
    fi
}
notifications_module_fnc

# Wakelock (always on mode)
wakelock_module="$WAKELOCK_PREFIX $WAKELOCK_ACTIVE"
wakelock_module_fnc() {
    if ! xset q | grep -q "DPMS is Disabled"; then
        wakelock_module=""
    fi
}
wakelock_module_fnc

# Formatted final output with proper margin
# Margin... using spaces. Sorry not sorry :)
modules=()

[[ -n "$wakelock_module" ]]      && modules+=(" $SPLITTER $wakelock_module")
[[ -n "$notifications_module" ]] && modules+=(" $SPLITTER $notifications_module")
[[ -n "$backlight_module" ]]     && modules+=(" $SPLITTER $backlight_module")
[[ -n "$battery_module" ]]       && modules+=(" $SPLITTER $battery_module")
[[ -n "$bluetooth_module" ]]     && modules+=(" $SPLITTER $bluetooth_module")
[[ -n "$network_module" ]]       && modules+=(" $SPLITTER $network_module")
[[ -n "$audio_module" ]]         && modules+=(" $SPLITTER $audio_module")
[[ -n "$keyboard_module" ]]      && modules+=(" $SPLITTER $keyboard_module")
[[ -n "$date_module" ]]          && modules+=(" $SPLITTER $date_module")

echo "${modules[*]}   $SPLITTER  "
