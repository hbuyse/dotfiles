#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

# Do not install if truenas
if [[ "${HOSTNAME}" == "truenas" ]]; then
    echo "Truenas host. Passing to next script"
    exit 0
fi

# Rustup
[[ "${OS}" == "freebsd" ]] && RUST_DEFAULT_HOST="x86_64-unknown-freebsd" || RUST_DEFAULT_HOST="x86_64-unknown-linux-gnu"
if ! cmdexists rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -q --no-modify-path --default-host "${RUST_DEFAULT_HOST}" --default-toolchain none --profile default -y
    rustup default stable
# Use the redirection since rustup check throw a Broken Pipe when filtering with grep -q
elif ! rustup check | grep "stable-${RUST_DEFAULT_HOST} - Up to date" >/dev/null; then
    rustup update
fi

# Rust compiler
# shellcheck source=/dev/null
source "${HOME}/.cargo/env"
if ! cmdexists "rustc"; then
    rustup install stable
fi

# Install rust-analyzer
if [[ "${OS}" == "linux" ]]; then
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - >"${HOME}/.local/bin/rust-analyzer"
    chmod +x "${HOME}/.local/bin/rust-analyzer"
fi

# Install cargo package
if cmdexists cargo; then
    declare -A CARGO_PKGS=(
        ["bottom"]="0.9.6"
        ["fd-find"]="9.0.0"
        ["stylua"]="0.20.0"
        ["ripgrep"]="14.1.0"
        ["du-dust"]="0.9.0"
    )

    if [[ "${OS}" == "linux" ]]; then
        CARGO_PKGS+=(
            ["alacritty"]="0.13.1"
        )
    fi

    for pkg in "${!CARGO_PKGS[@]}"; do
        cargo_install "${pkg}" "${CARGO_PKGS[${pkg}]}"
    done

    declare -A CARGO_GIT_PKGS=(
        ["https://github.com/latex-lsp/texlab"]="5.10.1"
    )

    for pkg in "${!CARGO_GIT_PKGS[@]}"; do
        cargo_git_install "${pkg}" "${CARGO_GIT_PKGS[${pkg}]}"
    done
fi
