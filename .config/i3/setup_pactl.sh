#!/bin/sh
HOSTNAME="$(hostname -s | tr '[:upper:]' '[:lower:]')"

# WORK
if [ "$HOSTNAME" = "henrib-latitude-5400" ] || [ "$HOSTNAME" = "t480" ]; then
    # Use internal PCI card
    pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo

    # Force headphones
    pactl set-sink-port alsa_output.pci-0000_00_1f.3.analog-stereo analog-output-headphones
fi
# vim: set ts=4 sw=4 tw=0 et :
