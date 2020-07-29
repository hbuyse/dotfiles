#!/usr/bin/env bash

exec 1> >(logger -s -p user.info -t "$(basename "$0")")
exec 2> >(logger -s -p user.err -t "$(basename "$0")")

rofi -show Power -modi Power:"$HOME/.config/rofi/power.sh"
