#! /usr/bin/env bash

DAEMON="conky"
CONKY_CONFIG_FOLDER="$HOME/.config/conky"
CONKIES=("$CONKY_CONFIG_FOLDER/conkyrc.date.time.$(hostname | tr '[:upper:]' '[:lower:]')" "$CONKY_CONFIG_FOLDER/conkyrc.proc.mem")

# Kill all processes even if the daemon binary does not exist
# The daemon may have been uninstalled
killall $DAEMON

# Check that the daemon command exist
if ! command -v $DAEMON 2> /dev/null; then
	echo "Conky not found. Exiting"
fi

for conky_conf in ${CONKIES[*]}; do
	$DAEMON -c "$conky_conf" -d
done
