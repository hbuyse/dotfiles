#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

# Need to hardcode them since we are using bash as shell interpreter (not zsh)
PYENV_PATH="${PYENV_ROOT:-${HOME}/.pyenv}/bin/pyenv"

display_info "${0}"

prompt "Install Pyenv prerequisites"
case "${OS}-${ID}" in
"linux-endeavouros" | "linux-arch" | "linux-manjaro")
    install_packages base-devel openssl zlib xz tk
    ;;
"linux-ubuntu")
    install_packages \
        build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev \
        xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    ;;
"linux-opensuse-tumbleweed")
    install_packages \
        gcc automake bzip2 libbz2-devel xz xz-devel openssl-devel ncurses-devel readline-devel zlib-devel tk-devel \
        libffi-devel sqlite3-devel gdbm-devel make findutils patch
    ;;
*) ;;

esac
display_ko_ok ${?}

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
        ["virtualenvwrapper"]="6.1.0"
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
