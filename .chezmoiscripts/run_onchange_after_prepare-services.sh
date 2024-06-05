#! /bin/bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

SERVICES=(
    "nextcloud"
    "lxpolkit"
)
case "${OS}-${ID}" in
"linux-manjaro" | "linux-arch" | "linux-opensuse-tumbleweed")
    SERVICES+=(
        "mako"
        "kanshi"
        "swayidle"
    )
    ;;
"linux-ubuntu")
    # SERVICES+=(
    #     "dunst"
    # )
    ;;
*)
    echo "Unsupported OS-distribution: '${OS}-${ID}'"
    exit 0
    ;;
esac

# Reload the services
systemctl --user daemon-reload

# Enable all services
for sv in "${SERVICES[@]}"; do
    systemctl --user enable --now "${sv}.service"
done

# vim: set ts=4 sw=4 tw=0 noet ft=sh :
