#!/usr/bin/env bash
# wrapper script for waybar with args, see https://github.com/swaywm/sway/issues/5724

LOG_FILE="$(mktemp -t XXXX.waybar.log)"

pkill -x waybar

for i in "${XDG_SESSION_DESKTOP}" config; do
    USER_CONFIG_PATH="$HOME/.config/waybar/$i.jsonc"
    if [ -f "$USER_CONFIG_PATH" ]; then
        USER_CONFIG=$USER_CONFIG_PATH
        break
    fi
done

USER_STYLE_PATH="$HOME/.config/waybar/style.css"
if [ -f "$USER_STYLE_PATH" ]; then
    USER_STYLE=$USER_STYLE_PATH
fi

env > "$LOG_FILE"
waybar -c "${USER_CONFIG:-"/usr/share/sway/templates/waybar/config.jsonc"}" -s "${USER_STYLE:-"/usr/share/sway/templates/waybar/style.css"}" >> "$LOG_FILE"
