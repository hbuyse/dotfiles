#!/usr/bin/env bash

exec 1> >(logger -s -p user.info -t "$(basename "$0")")
exec 2> >(logger -s -p user.err -t "$(basename "$0")")

UPTIME="$(uptime -p | sed -e 's/,//g')"

rofi -lines 7 -width 20 -show "${UPTIME}" -modi "${UPTIME}:${HOME}/.config/rofi/power.sh"
