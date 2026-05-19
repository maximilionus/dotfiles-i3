#!/usr/bin/env bash

# Do not update the status bar when the screen is locked.
if pgrep -x i3lock > /dev/null; then exit 0; fi

SPLITTER="    "

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
date_module=""
date_module_fnc() {
    date_module=$(date +'%e %a %H:%M')
}

# Keyboard
keyboard_module=""
keyboard_module_fnc() {
    keyboard_module="$KB_PREFIX"

    local mask=$((16#$(xset -q | awk '/LED mask:/ {print $NF}')))
    local layouts=$(setxkbmap -query | awk -F': *' '/layout:/ { print $2 }')
    local current_group=$(( (mask & 0x1000) ? 1 : 0 ))
    local caps_status=""

    if (( mask & 0x1 )); then
        caps_status="^"
    fi

    IFS=',' read -ra layout_array <<< "$layouts"

    keyboard_module="${keyboard_module} ${caps_status}${layout_array[$current_group]}"
}

# Audio
audio_module=""
audio_module_fnc() {
    audio_module="$VOLUME_PREFIX"

    local vol mute
    mute=$(pactl get-sink-mute "@DEFAULT_SINK@" | awk '{print $2}')

    if [[ "$mute" = "yes" ]]; then
        audio_module="$audio_module Muted"
        return
    fi
    vol=$(pactl get-sink-volume "@DEFAULT_SINK@" | awk -F'/' 'NR==1 {gsub(/ /,"",$2); print $2}')
    audio_module="$audio_module $vol"
}

# Battery
battery_module=""
battery_module_fnc() {
    battery_module=""
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

# Screen backlight
backlight_module=""
backlight_module_fnc() {
    backlight_module=""
    backlight_dir="/sys/class/backlight"
    device=$(ls "$backlight_dir" 2>/dev/null | head -n1)

    if [[ -n "$device" ]]; then
        max_brightness=$(cat "$backlight_dir/$device/max_brightness")
        cur_brightness=$(cat "$backlight_dir/$device/brightness")
        percent=$(( cur_brightness * 100 / max_brightness ))
        backlight_module="$BACKLIGHT_PREFIX  $percent%"
    fi
}

# Network
network_module=""
network_module_fnc() {
    network_module="$NET_PREFIX $NET_DOWN"
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

# Bluetooth
bluetooth_module=""
bluetooth_module_fnc() {
    bluetooth_module=""

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

# Notifications
notifications_module=""
notifications_module_fnc() {
    notifications_module=""

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

# Wakelock (always on mode)
wakelock_module=""
wakelock_module_fnc() {
    wakelock_module="$WAKELOCK_PREFIX $WAKELOCK_ACTIVE"

    if ! xset q | grep -q "DPMS is Disabled"; then
        wakelock_module=""
    fi
}

i=0
while true; do
    audio_module_fnc
    keyboard_module_fnc
    backlight_module_fnc
    notifications_module_fnc

    if (( i % 10 == 0 )); then
        battery_module_fnc
        network_module_fnc
        bluetooth_module_fnc
        wakelock_module_fnc
    fi

    if (( i % 59 == 0 )); then
        date_module_fnc
    fi

    # formatted final output with proper margin
    # margin... using spaces. sorry not sorry :)
    statusline=""

    [[ -n "$wakelock_module" ]]      && statusline+="${SPLITTER}$wakelock_module"
    [[ -n "$notifications_module" ]] && statusline+="${SPLITTER}$notifications_module"
    [[ -n "$backlight_module" ]]     && statusline+="${SPLITTER}$backlight_module"
    [[ -n "$battery_module" ]]       && statusline+="${SPLITTER}$battery_module"
    [[ -n "$bluetooth_module" ]]     && statusline+="${SPLITTER}$bluetooth_module"
    [[ -n "$network_module" ]]       && statusline+="${SPLITTER}$network_module"
    [[ -n "$audio_module" ]]         && statusline+="${SPLITTER}$audio_module"
    [[ -n "$keyboard_module" ]]      && statusline+="${SPLITTER}$keyboard_module"
    [[ -n "$date_module" ]]          && statusline+="${SPLITTER}$date_module"

    echo "${statusline}${SPLITTER}"
    ((i++))

    sleep 1
done
