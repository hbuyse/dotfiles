#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

# Do not install if truenas
if [[ "${HOSTNAME}" == "truenas" ]]; then
    echo "Truenas host. Passing to next script"
    exit 0
fi

case "${OS}-${ID}" in
"linux-manjaro" | "linux-arch" | "linux-opensuse-tumbleweed")
    install_packages rustup
    exit 0
    ;;

"linux-ubuntu" | "freebsd-freebsd")
    [[ "${OS}" == "freebsd" ]] && RUST_DEFAULT_HOST="x86_64-unknown-freebsd" || RUST_DEFAULT_HOST="x86_64-unknown-linux-gnu"
    if ! cmdexists rustup; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -q --no-modify-path --default-host "${RUST_DEFAULT_HOST}" --default-toolchain none --profile default -y
        # shellcheck source=/dev/null
        source "${HOME}/.cargo/env"
        rustup default stable
    # Use the redirection since rustup check throw a Broken Pipe when filtering with grep -q
    elif ! rustup check | grep "stable-${RUST_DEFAULT_HOST} - Up to date" > /dev/null; then
        rustup update
    fi

    # Rust compiler
    if ! cmdexists "rustc"; then
        rustup install stable
    fi
    ;;
*) ;;
esac
