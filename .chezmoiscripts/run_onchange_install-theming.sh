#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

function install_icons_papirus {
    case "${OS}-${ID}" in
    "linux-manjaro")
        install_packages papirus-icon-theme papirus-maia-icon-theme
        ;;
    "linux-arch" | "linux-opensuse-tumbleweed")
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
        aur_install_packages vimix-cursors
        ;;
    "linux-ubuntu" | "linux-opensuse-tumbleweed")
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
        aur_install_packages xcursor-breeze
        ;;
    "linux-ubuntu")
        install_packages breeze-cursor-theme
        ;;
    "linux-opensuse-tumbleweed")
        install_packages breeze6-cursors
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
        aur_install_packages matcha-gtk-theme
        ;;
    "linux-opensuse-tumbleweed")
        install_packages gtk2-metatheme-matcha gtk3-metatheme-matcha gtk4-metatheme-matcha
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
        aur_install_packages colloid-gtk-theme-git
        ;;
    "linux-ubuntu" | "linux-opensuse-tumbleweed")
        local colloid_version="2024-06-18"
        prompt "Downloading Colloid-gtk-theme in version '${colloid_version}'"
        wget -qO- "https://github.com/vinceliuice/Colloid-gtk-theme/archive/refs/tags/${colloid_version}.tar.gz" | tar -C "/tmp" -xz -f-
        display_ko_ok $?

        install_packages sassc

        prompt "Installing Colloid-gtk-theme"
        (
            cd "/tmp/Colloid-gtk-theme-${colloid_version}" || return
            ./install.sh --libadwaita --dest "${HOME}/.local/share/themes" --theme all --color all --tweaks all > /dev/null 2>&1
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

function install_theme_bat {
    mkdir -p "$(bat --config-dir)/themes"
    for i in "Latte" "Frappe" "Macchiato" "Mocha"; do
        wget -P "$(bat --config-dir)/themes" "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20${i}.tmTheme"
    done
    bat cache --build
}

install_icons_papirus
install_cursor_icons_vimix
install_cursor_icons_breeze
install_theme_matcha
install_theme_colloid
install_theme_bat
