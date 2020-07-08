#!/bin/sh

DAEMON="$(command -v bluetoothctl)"

if [ -n "$DAEMON" ]; then
	# Buetooth powered off
	if [ "$($DAEMON show | grep "Powered: yes" | wc -c)" -eq 0 ]; then
		echo "%{F#66ffffff}%{A1:$DAEMON power on&:}%{A}%{F-}"
	# Bluetooth powered on
	elif [ "$($DAEMON info | grep 'Device' | wc -c)" -eq 0 ]; then
		echo "%{A1:$DAEMON power off &:}%{A}"
	else
		echo "%{F#2193ff}%{A1:$DAEMON power off &:}%{A}%{F-}"
	fi
fi

