#!/usr/bin/env bash

exec 1> >(logger -s -p user.info -t "$(basename "$0")")
exec 2> >(logger -s -p user.err -t "$(basename "$0")")

UPTIME="Power"

vergte() {
    [ "$1" = "$(echo -e "$1\n$2" | sort -rV | head -n1)" ]
}

vergt() {
    [ "$1" = "$2" ] && return 1 || vergte $1 $2
}

if vergte "$(rofi -V | awk '{ print $2 }')" "1.6.0"; then
    UPTIME="$(uptime -p)"
fi

rofi -lines 7 -width 20 -show "${UPTIME}" -modi "${UPTIME}:${HOME}/.config/rofi/power.sh"
