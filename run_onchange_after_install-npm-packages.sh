#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

# Install npm packages
if cmdexists npm; then
    # Create NPM directory
    source "${CHEZMOI_SOURCE_DIR}/dot_npmrc"

    # shellcheck disable=SC2154
    mkdir -p "${prefix}"

    declare -A NPM_PKGS=(
        ["bash-language-server"]="5.1.2"
        ["diff-so-fancy"]="1.4.3"
        ["neovim"]="5.0.1"
        ["npm"]="10.5.0"
        ["prettier"]="3.2.5"
        ["pyright"]="1.1.353"
        ["typescript"]="5.4.2"
        ["typescript-language-server"]="4.3.3"
        ["vscode-langservers-extracted"]="4.8.0"
        ["yaml-language-server"]="1.14.0"
    )

    for pkg in "${!NPM_PKGS[@]}"; do
        npm_install "${pkg}" "${NPM_PKGS[${pkg}]}"
    done
fi