#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

# Need to hardcode them since we are using bash as shell interpreter (not zsh)
PIP_PATH="${HOME}/.pyenv/shims/pip"
PYENV_PATH="${HOME}/.pyenv/bin/pyenv"

pip_install() {
    local package="${1}"
    local version="${2}"

    if "${PIP_PATH}" freeze --local | grep -q "${package}==${version}"; then
        prompt "Installing '${package} v${version}' using pip"
        display_already_installed
    else
        local upgrade_opt=""
        if "${PIP_PATH}" freeze --local | grep -q "${package}"; then
            prompt "Updating '${package}' to version '${version}' using pip"
            upgrade_opt="--upgrade"
        else
            prompt "Installing '${package} v${version}' using pip"
        fi
        "${PIP_PATH}" install --quiet --user ${upgrade_opt} "${package}==${version}"
        display_ko_ok ${?}
    fi
}

display_info "${0}"

PYTHON_VERSION="3.10"
if ! command -v python3 | grep "${HOME}" > /dev/null; then
    prompt "Install Python ${PYTHON_VERSION}"
    "${PYENV_PATH}" install -f "${PYTHON_VERSION}"
    display_ko_ok ${?}

    prompt "Setting Python ${PYTHON_VERSION} as Python Interpreter"
    "${PYENV_PATH}" global "${PYTHON_VERSION}"
    display_ko_ok ${?}
fi

if cmdexists pip; then
    declare -A PIP_PKGS=(
        ["cmake-language-server"]="0.1.7"
        ["robotframework-lsp"]="1.11.0"
        ["codespell"]="2.2.6"
    )

    for pkg in "${!PIP_PKGS[@]}"; do
        pip_install "${pkg}" "${PIP_PKGS[${pkg}]}"
    done
fi
