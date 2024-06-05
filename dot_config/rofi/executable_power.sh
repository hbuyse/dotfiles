#!/usr/bin/env bash

lock() {
    systemctl --user kill --signal USR1 --kill-who=main swayidle.service
    return 0
}

list() {
    local size
    local icon_name
    local icon_folder
    icon_name="$1"
    size="$2"

    for folder in "${HOME}/.local/share/icons" "${HOME}/.icons" "/usr/local/share/icons" "/usr/share/icons"; do
        if [ -d "${folder}/${icon_name}" ]; then
            icon_folder="${folder}/${icon_name}"
            break
        fi
    done

    echo -en "Lock\0icon\x1f${icon_folder}/${size}x${size}/apps/system-lock-screen.svg\n"
    echo -en "Logout\0icon\x1f${icon_folder}/${size}x${size}/apps/system-log-out.svg\n"
    echo -en "Shutdown\0icon\x1f${icon_folder}/${size}x${size}/apps/system-shutdown.svg\n"
    echo -en "Reboot\0icon\x1f${icon_folder}/${size}x${size}/apps/system-reboot.svg\n"
    echo -en "Hibernate\0icon\x1f${icon_folder}/${size}x${size}/apps/system-suspend-hibernate.svg\n"
    echo -en "Suspend\0icon\x1f${icon_folder}/${size}x${size}/apps/system-suspend.svg\n"
    if pgrep --exact redshift > /dev/null; then
        echo -en "Deactivate Redshift\0icon\x1f${icon_folder}/${size}x${size}/panel/redshift-status-off.svg\n"
    else
        echo -en "Activate Redshift\0icon\x1f${icon_folder}/${size}x${size}/panel/redshift-status-on.svg\n"
    fi
    if [[ "$(xset q | grep "DPMS is " | awk '{ print $3 }' | tr "[:upper:]" "[:lower:]")" == "disabled" ]]; then
        echo -en "Uncaffeinate\0icon\x1f${icon_folder}/${size}x${size}/panel/caffeine-cup-empty.svg\n"
    else
        echo -en "Caffeinate\0icon\x1f${icon_folder}/${size}x${size}/panel/caffeine-cup-full.svg\n"
    fi
    if pgrep mako > "/dev/null"; then
        if makoctl mode | grep -qw do-not-disturb > /dev/null 2>&1; then
            echo -en "Do Disturb\0icon\x1f${icon_folder}/${size}x${size}/apps/bell.svg\n"
        else
            echo -en "Do Not Disturb\0icon\x1f${icon_folder}/${size}x${size}/apps/bell.svg\n"
        fi
    fi
}

if [[ -n "${1}" ]]; then
    case "${1}" in
    "Uncaffeinate")
        xautolock -enable
        xset -display :0 s 600 600 +dpms
        notify-send "Screen saver" "Enabled"
        ;;
    "Caffeinate")
        xautolock -disable
        xset -display :0 s off -dpms
        notify-send "Screen saver" "Disabled"
        ;;
    "Lock")
        lock && xset dpms force off
        ;;
    "Logout")
        swaymsg exit
        ;;
    "Shutdown")
        lock && systemctl poweroff
        ;;
    "Reboot")
        lock && systemctl reboot
        ;;
    "Hibernate")
        lock && sudo systemctl hibernate
        ;;
    "Suspend")
        lock && systemctl suspend
        ;;
    "Do Disturb")
        makoctl mode -r do-not-disturb > /dev/null 2>&1
        notify-send "Do Not Disturb" "Disabled"
        ;;
    "Do Not Disturb")
        makoctl mode -a do-not-disturb > /dev/null 2>&1
        ;;
    "Deactivate Redshift")
        pkill redshift
        ;;
    "Activate Redshift")
        "${HOME}/.config/redshift/launch.sh"
        ;;
    esac
else
    list Papirus 24
fi
# vim: set ts=4 sw=4 tw=0 et :
