#! /usr/bin/env sh
#
# Send notification saying which profile we are using
PROFILE="${1}"

cmdexists() {
    command -v "${1}" > /dev/null 2>&1
    return $?
}

if cmdexists notify-send; then
    notify-send "Kanshi" "Using profile '${PROFILE}'"
fi
