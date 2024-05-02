#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

if [ "${OS}-${ID}" = "linux-arch" ]; then
    install_packages \
        git \
        base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    makepkg --syncdeps --install --needed --noconfirm --nocheck --dir /tmp/yay
    rm -rf /tmp/yay
fi

case "${OS}-${ID}" in
"linux-manjaro" | "linux-arch")
    yay --sync --refresh --answerclean NotInstalled --answerdiff NotInstalled \
        i3lock-color \
        spotify
    ;;
*)
    echo "Unsupported distribution '${ID}' (based on OS '${OS}')"
    ;;
esac
