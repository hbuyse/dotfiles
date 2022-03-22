#!/bin/sh
HOSTNAME="$(hostname -s | tr '[:upper:]' '[:lower:]')"
CTL=pactl

if ! command -v ${CTL} > /dev/null; then
    echo "${CTL}: not found. Exiting..."
    exit 1
fi

# WORK
if [ "$HOSTNAME" = "hbuyse-latitude5400" ] || [ "$HOSTNAME" = "t480" ]; then
    # Use internal PCI card
    ${CTL} set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo

    # Force headphones
    ${CTL} set-sink-port alsa_output.pci-0000_00_1f.3.analog-stereo analog-output-headphones

    # Add loopback
    ${CTL} load-module module-loopback latency_msec=1
fi
# vim: set ts=4 sw=4 tw=0 et :
