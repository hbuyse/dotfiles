#!/usr/bin/env bash

POLYBAR="polybar"
XRANDR="xrandr"
BAR="$(hostname -s | tr '[:upper:]' '[:lower:]')"
LOG_DIR="/tmp/polybar"
POLYBAR_CONFIG="$(dirname "${BASH_SOURCE[0]}")/config.ini"
POLYBAR_START=()

function join_by {
    local d=${1-};
    local f=${2-};
    if shift 2; then
        printf %s "$f" "${@/#/$d}"
    fi
}

# Check that the commands exists
if ! command -v ${POLYBAR} > /dev/null 2>&1; then
    echo "${POLYBAR}: not found. Exiting." 1>&2
    exit 1
fi

# Terminate already running bar instances
killall -q -9 "${POLYBAR}"

# Create log directory
mkdir -p ${LOG_DIR}

# If all your bars have ipc enabled, you can also use polybar-msg cmd quit
if command -v "${XRANDR}" > /dev/null 2>&1; then
    for m in $(${XRANDR} --query | grep -w "connected" | cut -d" " -f1); do
        MONITOR="${m}" ${POLYBAR} --reload --config=${POLYBAR_CONFIG} "${BAR}"        > "${LOG_DIR}/${m}.log"        2>&1 &
        POLYBAR_START+=("${m}-${BAR}")
        MONITOR="${m}" ${POLYBAR} --reload --config=${POLYBAR_CONFIG} "${BAR}-bottom" > "${LOG_DIR}/${m}-bottom.log" 2>&1 &
        POLYBAR_START+=("${m}-${BAR}-bottom")
    done
else
    ${POLYBAR} --reload "${BAR}" > ${LOG_DIR}/main.log 2>&1 &
fi


notify-send "Polybar started" "$(join_by $'\n' ${POLYBAR_START[*]})"

# vim: set ts=4 sw=4 tw=0 et :
