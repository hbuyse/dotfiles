#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

npm_install() {
    local package="${1}"
    local version="${2}"
    local pkg_and_version="${package}@${version}"

    if [ -n "$(npm list --location=global -p "${pkg_and_version}")" ]; then
        prompt "Installing '${pkg_and_version}' using npm"
        display_already_installed
    elif [ -n "$(npm list --location=global -p "${package}")" ]; then
        prompt "Updating '${package}' to version '${version}' using npm"
        npm install --silent --location=global "${pkg_and_version}"
        local err=${?}
        if [ ${err} -eq 0 ]; then
            prompt "Updating '${package}' to version '${version}' using npm"
        fi
        display_ko_ok ${err}
    else
        prompt "Installing '${package} v${version}' using npm"
        npm install --silent --location=global "${pkg_and_version}"
        local err=${?}
        prompt "Installing '${package}' using npm"
        display_ko_ok ${err}
    fi
}

display_info "${0}"

# Install npm packages
if cmdexists npm; then
	# Create NPM directory
	source ${CHEZMOI_SOURCE_DIR}/dot_npmrc
	mkdir -p ${prefix}

    declare -A NPM_PKGS=(
        ["bash-language-server"]="5.0.0"
        ["diff-so-fancy"]="1.4.3"
        ["neovim"]="4.10.1"
        ["npm"]="10.2.4"
        ["pyright"]="1.1.337"
        ["typescript"]="5.3.2"
        ["typescript-language-server"]="4.1.2"
        ["vscode-langservers-extracted"]="4.8.0"
        ["yaml-language-server"]="1.14.0"
    )

    for pkg in "${!NPM_PKGS[@]}"; do
        npm_install "${pkg}" "${NPM_PKGS[${pkg}]}"
    done
fi
