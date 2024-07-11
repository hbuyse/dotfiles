#!/usr/bin/env sh
set -xu

export OUTLINE="$1"
export INSIDE="$2"
export BACKGROUND="$3"

# shellcheck disable=SC2002
cat "$HOME/.config/wallpapers/coding.svg" | envsubst > "$HOME/.config/wallpapers/generated_coding.svg"
