#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

# Need to hardcode them since we are using bash as shell interpreter (not zsh)
# PIP_PATH is used in utils.sh
export PIP_PATH="${HOME}/.pyenv/shims/pip"
PYENV_PATH="${HOME}/.pyenv/bin/pyenv"

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
        ["cmake-language-server"]="0.1.10"
        ["robotframework-lsp"]="1.12.0"
        ["pre-commit"]="3.7.0"
    )

    case "${OS}-${ID}" in
    "linux-arch" | "linux-manjaro")
        install_packages codespell
        ;;
    *)
        PIP_PKGS+=(["codespell"]="2.2.6")
        ;;
    esac

    for pkg in "${!PIP_PKGS[@]}"; do
        pip_install "${pkg}" "${PIP_PKGS[${pkg}]}"
    done
fi
