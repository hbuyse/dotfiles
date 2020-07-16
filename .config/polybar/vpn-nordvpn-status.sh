#! /usr/bin/env sh

DAEMON=nordvpn

if [ -n "$(command -v $DAEMON)" ]; then
	STATUS=$($DAEMON status | grep Status | tr -d ' ' | cut -d ':' -f2)

	if [ "$STATUS" = "Connected" ]; then
		echo "%{F#82E0AA}%{A1:$DAEMON d:}$($DAEMON status | grep City | cut -d ':' -f2)%{A}%{F-}"
	else
		echo "%{F#f00}%{A1:$DAEMON c:}no vpn%{A}%{F-}"
	fi
fi
