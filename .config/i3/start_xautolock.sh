#! /usr/bin/env sh

DAEMON="xautolock"

killall $DAEMON
$DAEMON -time 5 -locker "$HOME/.config/i3/i3lock-multi -i $HOME/.config/wallpapers/locker.png" \
        -killtime 15 -killer "systemctl suspend" \
        -detectsleep \
        -notify 30 -notifier "notify-send -u critical -t 29000 'i3lock' 'Will lock in 30 seconds'"
# vim: set ts=4 sw=4 tw=0 et ft=sh :
