#! /bin/bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

case "${OS}-${ID}" in
"linux-ubuntu" | "linux-manjaro")
    # Reload the services
    systemctl --user daemon-reload

    # Enable all the following user services
    SERVICES=(
        "nextcloud"
        "polkit-gnome-authentication-agent"
    )
    for sv in "${SERVICES[@]}"; do
        systemctl --user enable --now "${sv}.service"
    done
    ;;
*)
    echo "Unsupported OS-distribution: '${OS}-${ID}'"
    ;;
esac

# vim: set ts=4 sw=4 tw=0 noet ft=sh :
