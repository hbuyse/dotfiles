#!/usr/bin/env bash

OPTIONS="\tLock\n\tLogout\n\tShutdown\n\tReboot\n\tCaffeinate\n\tUncaffeinate\n\tRestart_i3"

if [ "$@" ]
then
	case $@ in
		*Uncaffeinate)
			xset +dpms
			;;
		*Caffeinate)
			xset -dpms
			;;
		*Lock)
			xautolock -locknow -locker "$HOME/.config/i3/i3lock-multi -i $HOME/.config/i3/locker.png"
			;;
		*Logout)
			i3-msg exit
			;;
		*Shutdown)
			shutdown now
			;;
		*Reboot)
			reboot
			;;
		*Restart_i3)
			i3-msg restart
			;;
	esac
else
	echo -e $OPTIONS
fi
