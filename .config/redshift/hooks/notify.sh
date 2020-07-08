#!/bin/sh

NOTIFY_DAEMON="notify-send"

# Exit if notify-send if not found
if ! command -v "${NOTIFY_DAEMON}" > /dev/null; then
	exit
fi

case $1 in
    period-changed)
        exec "$NOTIFY_DAEMON" "Redshift" "Period changed to $3"
esac

