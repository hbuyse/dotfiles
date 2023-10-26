#! /usr/bin/env bash

readonly RED="\e[1;31m"
readonly GREEN="\e[1;32m"
readonly YELLOW="\e[1;33m"
readonly DEFAULT="\e[0m"

readonly OS="${CHEZMOI_OS}"
readonly ID="${CHEZMOI_OS_RELEASE_ID}"
readonly IDLIKE="${CHEZMOI_OS_RELEASE_ID_LIKE}"

prompt() {
    echo -en "$*: "
}

display_already_installed() {
    echo -e "${YELLOW}already installed${DEFAULT}"
}

display_ko_ok() {
    [ "${1}" -eq 0 ] && echo -e "${GREEN}OK${DEFAULT}" || echo -e "${RED}KO${DEFAULT}"
}

cmdexists() {
    command -v "$1" > /dev/null && return 0 || return 1
}

display_info() {
    # Display some informations about the install
    echo "==================================="
    echo "Script: ${1}"
    echo "-----------------------------------"
    echo "Operating System: ${OS}"
    echo "Distribution ID: ${ID}"
    echo "Distribution IDLike: ${IDLIKE}"
    echo "User: ${USER}"
    echo "==================================="
}
