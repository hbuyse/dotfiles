#!/bin/bash

DAEMON=compton
OPTS="-b --config $HOME/.config/compton/compton.conf"

# Terminate already running compton instances
killall -q $DAEMON 

# Wait until the processes have been shut down
while pgrep -u $UID -x $DAEMON >/dev/null; do sleep 1; done

# Launch compton in background, using default config location ~/.config/compton/compton.conf
if [[ "$(hostname)" == "CG8250" ]]; then
	OPTS="$OPTS --backend=xrender"
fi
$DAEMON $OPTS
