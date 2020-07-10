#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit
if [[ -n "$(which xrandr)" ]]; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload work 2> /tmp/polybar-$m.log &
  done
else
  polybar --reload work 2> /tmp/polybar.log &
fi
# vim: set ts=2 sw=2 tw=0 et :
