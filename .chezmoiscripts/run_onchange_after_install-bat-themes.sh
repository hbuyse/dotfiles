#! /usr/bin/env bash

# Load the shell lib
# shellcheck source=../utils.sh
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

readonly INSTALL_DIR="${CHEZMOI_HOME_DIR}/.config/bat/themes"

declare -rA BAT_THEMES=(
    ["Catppuccin Latte"]="https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin Latte.tmTheme"
    ["Catppuccin Frappe"]="https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin Frappe.tmTheme"
    ["Catppuccin Macchiato"]="https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin Macchiato.tmTheme"
    ["Catppuccin Mocha"]="https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin Mocha.tmTheme"
)

for theme in "${!BAT_THEMES[@]}"; do
    prompt "Installing ${theme} bat theme"
    if [ -f "${INSTALL_DIR}/${theme}.tmTheme" ]; then
        display_already_installed
        continue
    fi

    wget --quiet --directory-prefix "${INSTALL_DIR}" "${BAT_THEMES[${theme}]}"
    display_ko_ok $?
done

prompt "Building bat cache"
bat cache --build > /dev/null 2>&1
display_ko_ok $?
