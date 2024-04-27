#! /bin/bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

SERVICES=(
    "nextcloud"
    "polkit-gnome-authentication-agent"
)
case "${OS}-${ID}" in
"linux-manjaro")
    # No more services to add
    ;;
"linux-ubuntu")
    # Enable all the following user services
    SERVICES+=(
        "dunst"
    )
    ;;
*)
    echo "Unsupported OS-distribution: '${OS}-${ID}'"
    exit 0
    ;;
esac

# Reload the services
systemctl --user daemon-reload

for sv in "${SERVICES[@]}"; do
    systemctl --user enable --now "${sv}.service"
done

# vim: set ts=4 sw=4 tw=0 noet ft=sh :
