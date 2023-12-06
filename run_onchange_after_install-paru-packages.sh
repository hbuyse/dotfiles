#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

case "${OS}-${ID}" in
"linux-manjaro")
    if ! cmdexists paru; then
        git clone https://aur.archlinux.org/paru.git /tmp/paru
        (cd /tmp/paru && makepkg -si)
        rm -rf /tmp/paru
    fi

    paru -Sy \
        cava \
        paru \
        i3lock-color
    ;;
*)
    echo "Unsupported distribution '${ID}' (based on OS '${OS}')"
    ;;
esac
