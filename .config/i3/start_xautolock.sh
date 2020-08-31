#! /usr/bin/env sh

killall xautolock
xautolock -time 5 -locker "$HOME/.config/i3/i3lock-multi -i $HOME/.config/i3/locker.png" -killtime 15 -killer "systemctl suspend" -detectsleep -notify 30 -notifier "notify-send -u critical -t 29000 'i3lock' 'Will lock in 30 seconds'"
