#! /usr/bin/env bash

DAEMONS=("picom" "compton")
HOSTNAME="$(hostname | tr '[:upper:]' '[:lower:]')"
DAEMON=""
OPTS=("--config" "${HOME}/.config/picom/picom.conf" "-b")

# Check for either picom or compton
for d in "${DAEMONS[@]}"; do
    if command -v "${d}" > /dev/null; then
        DAEMON=${d}
    fi
done

# If no daemon found, exit the program
if [ -z "${DAEMON}" ]; then
    echo "${DAEMONS[0]}: no command found. Exiting"
    exit 1
fi

if [[ $(pgrep -x -c "${DAEMON}") -ne 0 ]]; then
    # Reload config
    if killall -q -USR1 "${DAEMON}"; then
        notify-send -u "low" "Picom" "Configuration reloaded"
    else
        notify-send -u "critical" "Picom" "Error while reloading configuration"
    fi
else
    "${DAEMON}" "${OPTS[@]}"
fi
