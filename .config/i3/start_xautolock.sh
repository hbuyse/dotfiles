#! /usr/bin/env bash

DAEMON="xautolock"

killall $DAEMON

if ! command -v $DAEMON; then
    echo "$DAEMON not found. Exiting"
    exit
fi

DAEMON_ARGS=("-time 5")
DAEMON_ARGS+=("-locker \"$HOME/.config/i3/i3lock-multi -i $HOME/.config/wallpapers/locker.png\"")
DAEMON_ARGS+=("-notify 30 -notifier \"notify-send -u critical -t 29000 'i3lock' 'Will lock in 30 seconds'\"")

if [[ $HOSTNAME == "T480" || $HOSTNAME == "CG8250" ]]; then
    DAEMON_ARGS+=("-killtime 15 -killer \"systemctl suspend\"")
    DAEMON_ARGS+=("-detectsleep")
fi

eval "${DAEMON}" "${DAEMON_ARGS[*]}"
# vim: set ts=4 sw=4 tw=0 et ft=sh :
