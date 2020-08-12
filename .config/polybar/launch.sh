#!/usr/bin/env bash

POLYBAR="$(command -v polybar)"
XRANDR="$(command -v xrandr)"
BAR="$(hostname -s | tr '[:upper:]' '[:lower:]')"

# Check that the commands exists
if [[ -z "$POLYBAR" ]]; then
    exit 1
fi

# Terminate already running bar instances
killall -q "$POLYBAR"

# If all your bars have ipc enabled, you can also use polybar-msg cmd quit
if [[ -n "$XRANDR" ]]; then
    for m in $($XRANDR --query | grep -w "connected" | cut -d" " -f1); do
        MONITOR="$m" $POLYBAR --reload "$BAR" 2> "/tmp/polybar-$m.log" &
        MONITOR="$m" $POLYBAR --reload "$BAR-bottom" 2> "/tmp/polybar-$m-bottom.log" &
    done
else
    $POLYBAR --reload "$BAR" 2> /tmp/polybar.log &
fi
# vim: set ts=4 sw=4 tw=0 et :
