#!/usr/bin/env bash

OPTIONS="\tLock\n\tLogout\n\tShutdown\n\tReboot\n鈴\tSuspend\n\tCaffeinate\n\tUncaffeinate\n"

lock() {
	xautolock -locknow -locker "$HOME/.config/i3/i3lock-multi -i $HOME/.config/i3/locker.png"
}

if [ "$@" ]
then
	case $@ in
		*Uncaffeinate)
            xautolock -disable
			xset +dpms
           notify-send "Screen suspend" "Enabled"
			;;
		*Caffeinate)
            xautolock -enable
			xset -dpms
            notify-send "Screen suspend" "Disabled"
			;;
		*Lock)
			lock
			;;
		*Logout)
			i3-msg exit
			;;
		*Shutdown)
			lock && systemctl poweroff
			;;
		*Reboot)
			lock && systemctl reboot
			;;
		*Suspend)
			lock && systemctl suspend
			;;
	esac
else
	echo -e $OPTIONS
fi
