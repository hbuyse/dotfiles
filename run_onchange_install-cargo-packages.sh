#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

cargo_install() {
    local package="${1}"
    local version_and_features="${2}"
    local version
    local features
    local args_str

    version="$(echo "${version_and_features}" | cut -d',' -f1)"
    features="$(echo "${version_and_features}" | cut -d',' -f2-)"

    if [ "${version}" == "${features}" ]; then
        features=""
    fi

    if cargo install --list | grep -q "${package} v${version}"; then
        prompt "Installing '${package} v${version}' using cargo"
        display_already_installed
    else
        if cargo install --list | grep -q "${package}"; then
            prompt "Updating '${package}' to version '${version}' using cargo"
        else
            prompt "Installing '${package} v${version}' using cargo"
        fi

        if [ -n "${features}" ]; then
            args_str="--features=\"${features}\""
        fi

        cargo install --quiet --locked --jobs=4 --version="${version}" "${args_str}" "${package}"
        display_ko_ok ${?}
    fi
}

cargo_git_install() {
    local git_uri="${1}"
    local version_and_features="${2}"
    local package
    local version
    local features
    local args

    package="$(basename "${git_uri}")"
    version="$(echo "${version_and_features}" | cut -d',' -f1)"
    features="$(echo "${version_and_features}" | cut -d',' -f2-)"

    if [ "${version}" == "${features}" ]; then
        features=""
    fi

    if cargo install --list | grep -q "${package} v${version}"; then
        prompt "Installing '${package} v${version}' using cargo"
        display_already_installed
    else
        if cargo install --list | grep -q "${package}"; then
            prompt "Updating '${package}' to version '${version}' using cargo"
        else
            prompt "Installing '${package} v${version}' using cargo"
        fi

        if [ -n "${features}" ]; then
            args=("--features" "${features}")
        fi

        cargo install --quiet --locked --jobs=4 --tag="v${version}" "${args[*]}" --git "${git_uri}"
        display_ko_ok ${?}
    fi
}

display_info "${0}"

# Rustup
[[ "${OS}" == "freebsd" ]] && RUST_DEFAULT_HOST="x86_64-unknown-freebsd" || RUST_DEFAULT_HOST="x86_64-unknown-linux-gnu"
if ! cmdexists rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -q --no-modify-path --default-host "${RUST_DEFAULT_HOST}" --default-toolchain none --profile default -y
    rustup default stable
# Use the redirection since rustup check throw a Broken Pipe when filtering with grep -q
elif ! rustup check | grep "stable-${RUST_DEFAULT_HOST} - Up to date" > /dev/null; then
    rustup update
fi

# Rust compiler
# shellcheck source=/dev/null
source "${HOME}/.cargo/env"
if ! cmdexists "rustc"; then
    rustup install toolchain stable
fi

# Install cargo package
if cmdexists cargo; then
    declare -A CARGO_PKGS=(
        ["bottom"]="0.9.6"
        ["fd-find"]="8.7.0"
        ["stylua"]="0.18.2"
        ["ripgrep"]="13.0.0"
        ["du-dust"]="0.8.6"
        ["bat"]="0.23.0"
    )

    if [[ "${OS}" == "linux" ]]; then
        CARGO_PKGS+=(
            ["alacritty"]="0.12.3"
        )
    fi

    for pkg in ${!CARGO_PKGS[*]}; do
        cargo_install "${pkg}" "${CARGO_PKGS[${pkg}]}"
    done

    declare -A CARGO_GIT_PKGS=(
        ["https://github.com/latex-lsp/texlab"]="5.10.1"
    )

    for pkg in ${!CARGO_GIT_PKGS[*]}; do
        cargo_git_install "${pkg}" "${CARGO_GIT_PKGS[${pkg}]}"
    done
fi
