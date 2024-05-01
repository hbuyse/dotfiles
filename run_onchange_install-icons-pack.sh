#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

function install_icons_papirus {
    # Install Papirus icon theme
    local icon_dir="${HOME}/.local/share/icons"
    local extra_theme="Papirus-Dark"
    local papirus_version="20240201"

    if [ ! -d "${icon_dir}/Papirus" ]; then
        prompt "Installing Papirus Icon theme in version '${papirus_version}'"
    else
        prompt "Updating Papirus Icon theme to version '${papirus_version}'"
    fi

    wget -qO- "https://git.io/papirus-icon-theme-install" \
        | DESTDIR="${icon_dir}" \
            TAG="${papirus_version}" \
            EXTRA_THEMES="${extra_theme}" \
            sh
    display_ko_ok $?
}

install_icons_papirus
