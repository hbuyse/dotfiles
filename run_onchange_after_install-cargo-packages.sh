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
"linux-manjaro" | "linux-arch")
    install_packages \
        ripgrep \
        bottom \
        fd \
        stylua \
        dust \
        alacritty \
        texlab
    exit 0
    ;;

"freebsd-freebsd")
    install_packages \
        ripgrep \
        bottom \
        fd \
        stylua \
        dust \
        alacritty \
        texlab
    ;;

"linux-ubuntu")
    # shellcheck source=/dev/null
    source "${HOME}/.cargo/env"

    # Install cargo package
    if cmdexists cargo; then
        declare -A CARGO_GIT_PKGS=()
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

        for pkg in "${!CARGO_GIT_PKGS[@]}"; do
            cargo_git_install "${pkg}" "${CARGO_GIT_PKGS[${pkg}]}"
        done
    fi
    ;;

*)
    echo "Unsupported distribution '${ID}' (based on OS '${OS}')"
    exit 0
    ;;
esac
