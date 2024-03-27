#!/bin/sh
# wrapper script for waybar with args, see https://github.com/swaywm/sway/issues/5724

USER_CONFIG=$HOME/.config/waybar/config.jsonc
USER_STYLE=$HOME/.config/waybar/style.css

killall -9 waybar
waybar -c "${USER_CONFIG}" -s "${USER_STYLE}" &
