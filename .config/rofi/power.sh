#!/bin/bash

OPTIONS="\tLock\n\tLogout\n\tShutdown\n\tReboot"

option=`echo -e $OPTIONS | awk '{print $1}' | tr -d '\r\n\t'`
if [ "$@" ]
then
	case $@ in
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
	esac
else
	echo -e $OPTIONS
fi



