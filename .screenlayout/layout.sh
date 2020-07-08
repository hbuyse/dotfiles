#!/usr/bin/env bash
HOSTNAME="$(hostname -s | tr '[:upper:]' '[:lower:]')"
MONITORS_NB=$(xrandr --listmonitors | grep Monitors | awk '{ print $2 }')

# If one monitor, do nothing and exit
if [[ $MONITORS_NB -eq 1 ]]; then
    exit 0
fi

if [ "$HOSTNAME" != "cg8250" ] && [ "$HOSTNAME" != "t480" ]; then

    if [[ $MONITORS_NB -eq 3 ]]; then
        xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x1445 --rotate normal --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output DP-1-1 --mode 1920x1080 --pos 0x365 --rotate normal --output DP-1-2 --mode 1920x1080 --pos 1920x0 --rotate left --output DP-1-3 --off
    elif [[ $MONITORS_NB -eq 2 ]]; then
        xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x1080 --rotate normal --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-2 --off
    fi
fi
# vim: set ts=4 sw=4 tw=0 et :
