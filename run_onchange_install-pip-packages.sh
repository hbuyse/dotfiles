#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

pip_install() {
    local package="${1}"
    local version="${2}"

    if pip freeze --local | grep -q "${package}==${version}"; then
        prompt "Installing '${package} v${version}' using pip"
        display_already_installed
    else
        local upgrade_opt=""
        if pip freeze --local | grep -q "${package}"; then
            prompt "Updating '${package}' to version '${version}' using pip"
            upgrade_opt="--upgrade"
        else
            prompt "Installing '${package} v${version}' using pip"
        fi
        pip install --quiet --user ${upgrade_opt} "${package}==${version}"
        local err=${?}
        display_ko_ok ${err}
    fi
}

display_info "${0}"

if cmdexists pip; then
    declare -A PIP_PKGS=(
        ["cmake-language-server"]="0.1.7"
        ["robotframework-lsp"]="1.12.0"
        ["codespell"]="2.2.6"
    )

    for pkg in "${!PIP_PKGS[@]}"; do
        pip_install "${pkg}" "${PIP_PKGS[${pkg}]}"
    done
fi
