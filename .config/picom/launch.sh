#! /usr/bin/env bash

DAEMON="picom"

if [ ! command -v $DAEMON > /dev/null 2>&1 ]; then
	echo "picom: no command found. Exiting"
	exit 1
fi

$DAEMON
