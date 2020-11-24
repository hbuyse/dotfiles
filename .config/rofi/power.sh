#!/usr/bin/env bash

OPTIONS="\tLock\n\tLogout\n\tShutdown\n\tReboot\n鈴\tSuspend\n\tCaffeinate\n\tUncaffeinate\n"

lock() {
    xautolock -locknow
    return 0
}

list() {
    local size
    local icon_name
    icon_name="$1"
    size="$2"

    echo -en "Lock\0icon\x1f/usr/share/icons/${icon_name}/${size}x${size}/apps/system-lock-screen.svg\n"
    echo -en "Logout\0icon\x1f/usr/share/icons/${icon_name}/${size}x${size}/apps/system-log-out.svg\n"
    echo -en "Shutdown\0icon\x1f/usr/share/icons/${icon_name}/${size}x${size}/apps/system-shutdown.svg\n"
    echo -en "Reboot\0icon\x1f/usr/share/icons/${icon_name}/${size}x${size}/apps/system-reboot.svg\n"
    echo -en "Suspend\0icon\x1f/usr/share/icons/${icon_name}/${size}x${size}/apps/system-suspend.svg\n"
    echo -en "Caffeinate\0icon\x1f/usr/share/icons/${icon_name}/${size}x${size}/panel/caffeine-cup-full.svg\n"
    echo -en "Uncaffeinate\0icon\x1f/usr/share/icons/${icon_name}/${size}x${size}/panel/caffeine-cup-empty.svg\n"
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
            lock && xset dpms force off
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
    list Papirus 24
fi
# vim: set ts=4 sw=4 tw=0 et :
