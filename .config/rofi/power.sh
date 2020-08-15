#!/usr/bin/env bash

OPTIONS="\tLock\n\tLogout\n\tShutdown\n\tReboot\n鈴\tSuspend\n\tCaffeinate\n\tUncaffeinate\n"

if [ "$@" ]
then
	case $@ in
		*Uncaffeinate)
			xset +dpms && notify-send "Screen suspend" "Enabled"
			;;
		*Caffeinate)
			xset -dpms && notify-send "Screen suspend" "Disabled"
			;;
		*Lock)
			xautolock -locknow -locker "$HOME/.config/i3/i3lock-multi -i $HOME/.config/i3/locker.png"
			;;
		*Logout)
			i3-msg exit
			;;
		*Shutdown)
			systemctl poweroff
			;;
		*Reboot)
			systemctl reboot
			;;
		*Suspend)
			xautolock -locknow -locker "$HOME/.config/i3/i3lock-multi -i $HOME/.config/i3/locker.png" && systemctl suspend
			;;
	esac
else
	echo -e $OPTIONS
fi
