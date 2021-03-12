#! /usr/bin/env bash

readonly DAEMON="picom"
readonly HOSTNAME="$(hostname | tr '[:upper:]' '[:]')"
OPTS=("-b" "--config" "${HOME}/.config/compton/compton.conf")

# Terminate already running compton instances
killall -q -9 $DAEMON

# Launch compton in background, using default config location ~/.config/compton/compton.conf
if [[ "$(hostname | tr '[:upper:]' '[:]')" == "CG8250" ]]; then
	OPTS="$OPTS --backend=xrender"
fi
$DAEMON $OPTS
