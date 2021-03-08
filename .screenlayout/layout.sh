#!/usr/bin/env bash

DAEMON="xrandr"
HOSTNAME="$(hostname -s | tr '[:upper:]' '[:lower:]')"
MONITORS_NB=$(xrandr --query | grep -wc connected)

# sleep 1
OPTIONS=()
OPTIONS+=(--output DP-1 --off)
OPTIONS+=(--output HDMI-2 --off)

if ! command -v $DAEMON > /dev/null 2>&1; then
    echo "xrandr not found. Exiting." 1>&2
    exit 1
fi
MONITORS_NB=3
case $MONITORS_NB in
    3)
        OPTIONS+=(--output eDP-1 --primary --mode 1920x1080 --pos 0x1445 --rotate normal)
        OPTIONS+=(--output HDMI-1 --off)
        OPTIONS+=(--output DP-1-1 --mode 1920x1080 --pos 0x365 --rotate normal)
        OPTIONS+=(--output DP-1-2 --mode 1920x1080 --pos 1920x0 --rotate left)
        OPTIONS+=(--output DP-1-3 --off)
        ;;
    2)
        OPTIONS+=(--output eDP-1 --primary --mode 1920x1080 --pos 0x1080 --rotate normal)
        OPTIONS+=(--output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal)
        ;;
    *)
        exit 0
esac

if [ "$1" = "-d" ]; then
    OPTIONS+=(--verbose)
fi

eval $DAEMON ${OPTIONS[*]}
 # vim: set ts=4 sw=4 tw=0 et ft=sh :
