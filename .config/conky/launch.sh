#! /usr/bin/env bash

readonly DAEMON="conky"
readonly CONKY_CONFIG_FOLDER="${HOME}/.config/conky"
readonly CONKIES=("${CONKY_CONFIG_FOLDER}/conkyrc.date.time.$(hostname | tr '[:upper:]' '[:lower:]')" "${CONKY_CONFIG_FOLDER}/conkyrc.proc.mem")
readonly LOG_FOLDER="/tmp/conky/"

# Check that the daemon command exist
if ! command -v ${DAEMON} > "/dev/null"; then
	echo "Conky not found. Exiting"
	exit 1
fi

# Kill all processes even if the daemon binary does not exist
# The daemon may have been uninstalled
killall -q -9 ${DAEMON}

# Create log folder
mkdir -p ${LOG_FOLDER}

# Launch conkies
for conky_conf in ${CONKIES[*]}; do
	${DAEMON} -c "${conky_conf}" -d > "$(mktemp -p ${LOG_FOLDER} conky.XXXXXXXXXX.log)" 2>&1
done
# vim: set ts=4 sw=4 tw=0 et ft=sh :
