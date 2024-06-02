#!/usr/bin/env bash

function lock() {
    case "${XDG_SESSION_TYPE}-${XDG_SESSION_DESKTOP}" in
    "wayland-sway")
        pkill -USR1 swayidle
        ;;
    "wayland-hyprland")
        hyprlock --immediate
        ;;
    "x11-i3")
        xautolock -locknow
        ;;
    esac
}

function logout() {
    case "${XDG_SESSION_TYPE}-${XDG_SESSION_DESKTOP}" in
    "wayland-sway")
        swaymsg exit
        ;;
    "wayland-hyprland")
        hyprctl dispatch exit
        ;;
    "x11-i3")
        i3-msg exit
        ;;
    esac
}

function list() {
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

    echo -en "img:${icon_folder}/${size}x${size}/apps/system-lock-screen.svg:text:Lock\n"
    echo -en "img:${icon_folder}/${size}x${size}/apps/system-log-out.svg:text:Logout\n"
    echo -en "img:${icon_folder}/${size}x${size}/apps/system-shutdown.svg:text:Shutdown\n"
    echo -en "img:${icon_folder}/${size}x${size}/apps/system-reboot.svg:text:Reboot\n"
    echo -en "img:${icon_folder}/${size}x${size}/apps/system-suspend.svg:text:Suspend\n"
    # if [[ "$(xset q | grep "DPMS is " | awk '{ print $3 }' | tr "[:upper:]" "[:lower:]")" == "disabled" ]]; then
    #     echo -en "img:${icon_folder}/${size}x${size}/panel/caffeine-cup-empty.svg:text:Uncaffeinate\n"
    # else
    #     echo -en "img:${icon_folder}/${size}x${size}/panel/caffeine-cup-full.svg:text:Caffeinate\n"
    # fi
    if pgrep mako > "/dev/null"; then
        if makoctl mode | grep -qw do-not-disturb > /dev/null 2>&1; then
            echo -en "img:${icon_folder}/${size}x${size}/apps/bell.svg:text:Do Disturb\n"
        else
            echo -en "img:${icon_folder}/${size}x${size}/apps/bell.svg:text:Do Not Disturb\n"
        fi
    fi
}

function run() {
    if [[ -n "${1}" ]]; then
        case "${1}" in
        # "Uncaffeinate")
        #     xautolock -enable
        #     xset -display :0 s 600 600 +dpms
        #     notify-send "Screen saver" "Enabled"
        #     ;;
        # "Caffeinate")
        #     xautolock -disable
        #     xset -display :0 s off -dpms
        #     notify-send "Screen saver" "Disabled"
        #     ;;
        "Lock")
            lock
            ;;
        "Logout")
            logout
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
            makoctl mode -r do-not-disturb > /dev/null 2>&1
            notify-send "Do Not Disturb" "Disabled"
            ;;
        "Do Not Disturb")
            makoctl mode -a do-not-disturb > /dev/null 2>&1
            ;;
        *) ;;
        esac
    else
        output=$(list Papirus 24 | wofi --dmenu --cache-file="/dev/null" --prompt="$(uptime -p | sed -e 's/,//g')" | cut -d ':' -f 4)
        if [[ -n "${output}" ]]; then
            run $output
        fi
    fi
}

if [ -z "$XDG_SESSION_DESKTOP" ]; then
    XDG_SESSION_DESKTOP="${XDG_CURRENT_DESKTOP}"
fi

run
# vim: set ts=4 sw=4 tw=0 et :
