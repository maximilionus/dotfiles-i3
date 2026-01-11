#!/usr/bin/env bash

OPTIONS="Poweroff
Suspend
Reboot
Logout"

selected_option=$(echo "$OPTIONS" | wmenu -p "Select an option")

case "$selected_option" in
    Poweroff)
        systemctl poweroff
        ;;
    Suspend)
        systemctl suspend
        ;;
    Reboot)
        systemctl reboot
        ;;
    Logout)
        swaymsg exit
        ;;
esac
