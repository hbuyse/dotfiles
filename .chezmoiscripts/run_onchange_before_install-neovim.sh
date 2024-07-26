#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

case "${OS}-${ID}" in
"linux-manjaro" | "linux-arch" | "freebsd-freebsd")
    prompt "Installing Neovim ${NEOVIM_VERSION} from package manager"
    install_packages neovim
    display_ko_ok $?
    ;;

"linux-ubuntu")
    NEOVIM_VERSION="0.10.1"
    NEOVIM_TMP_FILE=$(mktemp /tmp/nvim-linux64-XXXXX.tar.gz)

    prompt "Downloading Neovim ${NEOVIM_VERSION} from GitHub"
    curl --silent --location --output "${NEOVIM_TMP_FILE}" "https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz"
    display_ko_ok $?

    prompt "Installing Neovim ${NEOVIM_VERSION} from GitHub"
    tar -C "${HOME}/.local" --strip-components 1 -zvxf "${NEOVIM_TMP_FILE}"
    display_ko_ok $?

    prompt "Remove downloaded archive"
    rm -f "${NEOVIM_TMP_FILE}"
    display_ko_ok $?
    ;;
*)
    echo "Unsupported distribution '${ID}' (based on OS '${OS}')"
    ;;
esac
# vim: set ts=4 sw=4 tw=0 et ft=sh :
