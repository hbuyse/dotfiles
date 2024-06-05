#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

# Install npm packages
if ! cmdexists npm; then
    exit 0
fi

# Create NPM directory
source "${CHEZMOI_SOURCE_DIR}/dot_npmrc"

# shellcheck disable=SC2154
mkdir -p "${prefix}"

declare -A NPM_PKGS=(
    ["neovim"]="5.1.0"
    ["prettier"]="3.3.1"
)

if [ "${OS}-${ID}" = "linux-ubuntu" ]; then
    NPM_PKGS["npm"]="10.8.1"
fi

for pkg in "${!NPM_PKGS[@]}"; do
    npm_install "${pkg}" "${NPM_PKGS[${pkg}]}"
done
