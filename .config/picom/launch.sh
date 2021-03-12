#! /usr/bin/env bash

readonly DAEMONS=("picom" "compton")
readonly HOSTNAME="$(hostname | tr '[:upper:]' '[:]')"
DAEMON=""
OPTS=("--config" "${HOME}/.config/picom/picom.conf")

# Check for either picom or compton
for d in ${DAEMONS[*]}; do
	if command -v ${d} > /dev/null; then
		DAEMON=${d}
	fi
done

# If no daemon found, exit the program
if [ -z ${DAEMON} ]; then
	echo "${DAEMONS[0]}: no command found. Exiting"
	exit 1
fi

# Kill all processes
killall -q -9 ${DAEMON}

# Launch compton in background, using default config location ~/.config/compton/compton.conf
if [[ "${HOSTNAME}" == "cg8250" ]]; then
	OPTS+=("--backend=xrender")
fi

eval ${DAEMON} ${OPTS[*]}
