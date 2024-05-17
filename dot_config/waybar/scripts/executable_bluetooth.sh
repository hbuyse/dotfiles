#! /usr/bin/env bash
#
# Handle the different status of the bluetooth

poweron() {
    bluetoothctl power on
}

poweroff() {
    bluetoothctl power off
}

toggle_power() {
    local status
    status="$(bluetoothctl show | grep PowerState | awk '{ print $2 }')"
    case "${status}" in
    "off")
        poweron
        ;;
    "on")
        poweroff
        ;;
    *)
        echo "Unknown status: '${status}'"
        ;;
    esac
}

case "${1}" in
"check")
    command -v bluetoothctl
    return $?
    ;;
"toggle_power")
    toggle_power
    ;;
"toggle_status")
    rfkill toggle bluetooth
    ;;
*)
    echo "Unknown command: '${1}'"
    ;;
esac
