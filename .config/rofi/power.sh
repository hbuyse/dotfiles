#!/usr/bin/env bash

OPTIONS="\tLock\n\tLogout\n\tShutdown\n\tReboot\n鈴\tSuspend\n\tCaffeinate\n\tUncaffeinate\n"

lock() {
    xautolock -locknow
    return 0
}

if [ "$@" ]
then
    case $@ in
        *Uncaffeinate)
            xautolock -enable
            xset -dpms
            notify-send "Screen suspend" "Enabled"
            ;;
        *Caffeinate)
            xautolock -disable
            xset +dpms
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
# vim: set ts=4 sw=4 tw=0 et :
