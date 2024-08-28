#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

case "${OS}-${ID}" in
"linux-endeavouros" | "linux-manjaro" | "linux-arch")
    aur_install_packages \
        i3lock-color \
        spotify \
        swaylock-effects
    ;;
*)
    echo "Unsupported distribution '${ID}' (based on OS '${OS}')"
    ;;
esac
