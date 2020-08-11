#!/bin/sh

CHARGING=""

BATTERY_10=""  # 00 -> 10
BATTERY_33=""  # 11 -> 33
BATTERY_55=""  # 34 -> 55
BATTERY_78=""  # 56 -> 78
BATTERY_100="" # 79 -> 100
ICON=""

# GRUVBOX COLORS
aqua1="#688d6a"
aqua2="#8ec07c"
blue1="#458588"
blue2="#83a598"
gray1="#a89984"
gray2="#928374"
green1="#98971a"
green2="#b8bb26"
orange1="#d65d0e"
orange2="#fe8019"
purple1="#b16286"
purple2="#d3869b"
red1="#cc241d"
red2="#fb4934"
yellow1="#d79921"
yellow2="#fabd2f"

COLOR="#ffffff"

# Check if charging
sudo tlp-stat -b | grep -q "Charging" && ICON="$ICON $CHARGING"

# Get the battery percentage
battery=$(sudo tlp-stat -b | tac | grep -m 1 "Charge" |  tr -d -c "[:digit:],.")

# Select underline color and icon
if (( $(echo "$battery <= 10" | bc -l) )); then
	COLOR="$red2"
	ICON="$ICON $BATTERY_10"
elif (( $(echo "$battery <= 33" | bc -l) )); then
	COLOR="$orange2"
	ICON="$ICON $BATTERY_33"
elif (( $(echo "$battery <= 55" | bc -l) )); then
	COLOR="$yellow2"
	ICON="$ICON $BATTERY_55"
elif (( $(echo "$battery <= 78" | bc -l) )); then
	COLOR="$green2"
	ICON="$ICON $BATTERY_78"
else
	COLOR="$aqua2"
	ICON="$ICON $BATTERY_100"
fi

# Send the output
echo "%{u$COLOR}%{+u}$ICON  $battery%%{-u}"
