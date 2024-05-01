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

function install_cursor_icons_vimix {
    local vimix_version="2020-02-24"
    prompt "Downloading Vimix vursors in version '${vimix_version}'"
    wget -qO- "https://github.com/vinceliuice/Vimix-cursors/archive/refs/tags/${vimix_version}.tar.gz" | tar -C "/tmp" -xz -f-
    display_ko_ok $?

    prompt "Installing Vimix-cursors"
    (
        cd "/tmp/Vimix-cursors-${vimix_version}" || return
        ./install.sh > /dev/null 2>&1
    )
    display_ko_ok $?

    prompt "Removing /tmp/Vimix-cursors-${vimix_version}"
    rm -rf "/tmp/Vimix-cursors-${vimix_version}"
    display_ko_ok $?
}

install_icons_papirus
install_cursor_icons_vimix
