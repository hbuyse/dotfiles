#!/usr/bin/env bash

OPTIONS="\tLock\n\tLogout\n\tShutdown\n\tReboot\n鈴\tSuspend\n\tCaffeinate\n\tUncaffeinate\n"

LOCK_CMD="xautolock -locknow -locker \"$HOME/.config/i3/i3lock-multi -i $HOME/.config/i3/locker.png\""

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
			$LOCK_CMD
			;;
		*Logout)
			i3-msg exit
			;;
		*Shutdown)
			$LOCK_CMD && systemctl poweroff
			;;
		*Reboot)
			$LOCK_CMD && systemctl reboot
			;;
		*Suspend)
			$LOCK_CMD && systemctl suspend
			;;
	esac
else
	echo -e $OPTIONS
fi
