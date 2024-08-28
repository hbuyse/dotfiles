#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

# Need to hardcode them since we are using bash as shell interpreter (not zsh)
PYENV_PATH="${PYENV_ROOT:-${HOME}/.pyenv}/bin/pyenv"

display_info "${0}"

PYTHON_VERSION="3.12"
prompt "Install Python ${PYTHON_VERSION}"
"${PYENV_PATH}" install -s "${PYTHON_VERSION}"
display_ko_ok ${?}

prompt "Setting Python ${PYTHON_VERSION} as Python Interpreter"
"${PYENV_PATH}" global "${PYTHON_VERSION}"
display_ko_ok ${?}

if cmdexists pip; then
    declare -A PIP_PKGS=(
        ["cmake-language-server"]="0.1.10"
        ["robotframework-lsp"]="1.12.0"
    )

    case "${OS}-${ID}" in
    "linux-endeavouros" | "linux-arch" | "linux-manjaro")
        install_packages codespell pre-commit
        ;;
    *)
        PIP_PKGS+=(["codespell"]="2.2.6")
        PIP_PKGS+=(["pre-commit"]="3.7.0")
        ;;
    esac

    for pkg in "${!PIP_PKGS[@]}"; do
        pip_install "${pkg}" "${PIP_PKGS[${pkg}]}"
    done
fi
