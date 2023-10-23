#! /usr/bin/env bash

DAEMON="xautolock"
HOSTNAME="$(hostname -s | tr '[:upper:]' '[:lower:]')"

OPTS=("-time 5")
if command -v betterlockscreen > /dev/null; then
    # The generation of lockscreen is done in the autorandr postswitch script
    OPTS+=("-locker \"betterlockscreen -l\"")
else
    OPTS+=("-locker \"i3lock\"")
fi

OPTS+=("-notify 30 -notifier \"notify-send -u critical -t 29000 'i3lock' 'Will lock in 30 seconds'\"")

if ! command -v $DAEMON; then
    echo "$DAEMON not found. Exiting"
    exit
fi

if [[ $HOSTNAME == "t480" ]] || [[ $HOSTNAME == "cg8250" ]]; then
    OPTS+=("-killtime 15 -killer \"systemctl suspend\"")
    OPTS+=("-detectsleep")
fi

killall $DAEMON
eval "${DAEMON}" "${OPTS[*]}"
# vim: set ts=4 sw=4 tw=0 et ft=sh :
