#! /usr/bin/env bash

readonly DAEMON=redshift
readonly CONF="$HOME/.config/redshift/redshift.conf"

# Check if the command exists
if ! command -v "${DAEMON}" > /dev/null; then
	echo "${DAEMON} not found. Exiting"
	exit
fi

# Kill all previous instances of the daemon
pkill -9 "${DAEMON}"

# Remove adjustment from screen
${DAEMON} -x

# Start the daemon
${DAEMON} -c "${CONF}"
