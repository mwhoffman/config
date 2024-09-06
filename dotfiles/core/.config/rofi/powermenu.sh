#!/bin/bash

# Power menu script.

ACTION=$(echo -ne "Log Out\0icon\x1fxfsm-logout\nReboot\0icon\x1fxfsm-reboot\nShutdown\0icon\x1fxfsm-shutdown" |
    rofi -i -dmenu -theme $HOME/.config/rofi/powermenu.rasi)

case "$ACTION" in
	"Log Out") i3-msg exit ;;
	"Reboot") reboot ;;
	"Shutdown") poweroff ;;
	*) exit 1 ;;
esac
