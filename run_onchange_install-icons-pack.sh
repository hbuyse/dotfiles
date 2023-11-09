#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

# Install Papirus icon theme
ICON_DIR="${HOME}/.local/share/icons"
ICON_THEME="Papirus"
PAPIRUS_VERSION="20231101"
if [ ! -d "${ICON_DIR}/${ICON_THEME}" ]; then
    prompt "Installing Papirus Icon theme in version '${PAPIRUS_VERSION}'"
else
    prompt "Updating Papirus Icon theme to version '${PAPIRUS_VERSION}'"
fi
wget -qO- https://git.io/papirus-icon-theme-install \
    | DESTDIR="${ICON_DIR}" \
        ICON_THEMES="${ICON_THEME}" \
        TAG="${PAPIRUS_VERSION}" \
        EXTRA_THEMES="" \
        sh
display_ko_ok $?
