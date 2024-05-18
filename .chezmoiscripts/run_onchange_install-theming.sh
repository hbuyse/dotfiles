#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

function install_icons_papirus {
    case "${OS}-${ID}" in
    "linux-manjaro")
        install_packages papirus-icon-theme papirus-maia-icon-theme
        ;;
    "linux-arch")
        install_packages papirus-icon-theme
        ;;
    "linux-ubuntu")
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
        ;;
    *)
        return
        ;;
    esac
}

function install_cursor_icons_vimix {
    case "${OS}-${ID}" in
    "linux-manjaro" | "linux-arch")
        yay -S --noconfirm --noanswerdiff vimix-cursors
        ;;
    "linux-ubuntu")
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
        ;;
    *)
        return
        ;;
    esac
}

function install_cursor_icons_breeze {
    case "${OS}-${ID}" in
    "linux-manjaro")
        install_packages xcursor-breeze
        ;;
    "linux-arch")
        yay -S --noconfirm --noanswerdiff xcursor-breeze
        ;;
    "linux-ubuntu")
        install_packages breeze-cursor-theme
        ;;
    *)
        return
        ;;
    esac
}

function install_theme_matcha {
    case "${OS}-${ID}" in
    "linux-manjaro")
        install_packages matcha-gtk-theme
        ;;
    "linux-arch")
        yay -S --noconfirm --noanswerdiff matcha-gtk-theme
        ;;
    "linux-ubuntu")
        local matcha_version="2024-05-01"
        prompt "Downloading Matcha-gtk-theme in version '${matcha_version}'"
        wget -qO- "https://github.com/vinceliuice/Matcha-gtk-theme/archive/refs/tags/${matcha_version}.tar.gz" | tar -C "/tmp" -xz -f-
        display_ko_ok $?

        prompt "Installing Matcha-gtk-theme"
        (
            cd "/tmp/Matcha-gtk-theme-${matcha_version}" || return
            ./install.sh -l > /dev/null 2>&1
        )
        display_ko_ok $?

        prompt "Removing /tmp/Matcha-gtk-theme-${matcha_version}"
        rm -rf "/tmp/Matcha-gtk-theme-${matcha_version}"
        display_ko_ok $?
        ;;
    *)
        return
        ;;
    esac
}

function install_theme_colloid {
    case "${OS}-${ID}" in
    "linux-arch" | "linux-manjaro")
        yay -S --noconfirm --noanswerdiff colloid-gtk-theme-git
        ;;
    "linux-ubuntu")
        local colloid_version="2024-05-13"
        prompt "Downloading Colloid-gtk-theme in version '${colloid_version}'"
        wget -qO- "https://github.com/vinceliuice/Colloid-gtk-theme/archive/refs/tags/${colloid_version}.tar.gz" | tar -C "/tmp" -xz -f-
        display_ko_ok $?

        prompt "Installing Colloid-gtk-theme"
        (
            cd "/tmp/Colloid-gtk-theme-${colloid_version}" || return
            ./install.sh -l > /dev/null 2>&1
        )
        display_ko_ok $?

        prompt "Removing /tmp/Colloid-gtk-theme-${colloid_version}"
        rm -rf "/tmp/Colloid-gtk-theme-${colloid_version}"
        display_ko_ok $?
        ;;
    *)
        return
        ;;
    esac
}

install_icons_papirus
install_cursor_icons_vimix
install_cursor_icons_breeze
install_theme_matcha
install_theme_colloid
