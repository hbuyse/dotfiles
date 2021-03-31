#!/usr/bin/env bash

lock() {
    xautolock -locknow
    return 0
}

list() {
    local size
    local icon_name
    icon_name="$1"
    size="$2"

    echo -en "Lock\0icon\x1f${HOME}/.local/share/icons/${icon_name}/${size}x${size}/apps/system-lock-screen.svg\n"
    echo -en "Logout\0icon\x1f${HOME}/.local/share/icons/${icon_name}/${size}x${size}/apps/system-log-out.svg\n"
    echo -en "Shutdown\0icon\x1f${HOME}/.local/share/icons/${icon_name}/${size}x${size}/apps/system-shutdown.svg\n"
    echo -en "Reboot\0icon\x1f${HOME}/.local/share/icons/${icon_name}/${size}x${size}/apps/system-reboot.svg\n"
    echo -en "Suspend\0icon\x1f${HOME}/.local/share/icons/${icon_name}/${size}x${size}/apps/system-suspend.svg\n"
    if [[ "$(xset q | grep "DPMS is " | awk '{ print $3 }' | tr "[:upper:]" "[:lower:]")" == "disabled" ]]; then
        echo -en "Caffeinate\0icon\x1f${HOME}/.local/share/icons/${icon_name}/${size}x${size}/panel/caffeine-cup-full.svg\n"
    else
        echo -en "Uncaffeinate\0icon\x1f${HOME}/.local/share/icons/${icon_name}/${size}x${size}/panel/caffeine-cup-empty.svg\n"
    fi
    if pgrep dunst > "/dev/null"; then
        if [[ "$(dunstctl is-paused)" == "true" ]]; then
            echo -en "Do Disturb\0icon\x1f${HOME}/.local/share/icons/${icon_name}/${size}x${size}/apps/bell.svg\n"
        elif [[ "$(dunstctl is-paused)" == "false" ]]; then
            echo -en "Do Not Disturb\0icon\x1f${HOME}/.local/share/icons/${icon_name}/${size}x${size}/apps/bell.svg\n"
        fi
    fi
}

if [[ -n "$@" ]]
then
    case "$@" in
        "Uncaffeinate")
            xautolock -enable
            xset s 1800 1800 -dpms
            notify-send "Screen saver" "Enabled"
            ;;
        "Caffeinate")
            xautolock -disable
            xset s 600 600 +dpms
            notify-send "Screen saver" "Disabled"
            ;;
        "Lock")
            lock && xset dpms force off
            ;;
        "Logout")
            i3-msg exit
            ;;
        "Shutdown")
            lock && systemctl poweroff
            ;;
        "Reboot")
            lock && systemctl reboot
            ;;
        "Suspend")
            lock && systemctl suspend
            ;;
        "Do Disturb")
            dunstctl set-paused false
            notify-send "Do Not Disturb" "Disabled"
            ;;
        "Do Not Disturb")
            dunstctl set-paused true
            ;;
    esac
else
    list Papirus 24
fi
# vim: set ts=4 sw=4 tw=0 et :
