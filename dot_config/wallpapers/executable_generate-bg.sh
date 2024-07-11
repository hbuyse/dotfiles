#!/usr/bin/env sh
set -u

export OUTLINE="$1"
export INSIDE="$2"
export BACKGROUND="$3"

# shellcheck disable=SC2002
cat "$HOME/.config/wallpapers/coding.svg" | envsubst > "$HOME/.config/wallpapers/generated_coding.svg"
ln -sf "$HOME/.config/wallpapers/generated_coding.svg" "$HOME/.config/wallpapers/wallpaper"
ln -sf "$HOME/.config/wallpapers/generated_coding.svg" "$HOME/.config/wallpapers/locker"
