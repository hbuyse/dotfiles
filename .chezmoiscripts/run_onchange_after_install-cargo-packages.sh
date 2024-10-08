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
"linux-endeavouros" | "linux-manjaro" | "linux-arch" | "freebsd-freebsd")
    install_packages \
        ripgrep \
        bottom \
        fd \
        stylua \
        dust \
        git-delta \
        alacritty \
        texlab \
        zoxide \
        gitui \
        eza \
        bat
    ;;

"linux-opensuse-tumbleweed")
    install_packages \
        ripgrep \
        bottom \
        fd \
        StyLua \
        dust \
        git-delta \
        alacritty \
        texlab \
        zoxide \
        gitui \
        eza \
        bat
    ;;

"linux-ubuntu")
    # shellcheck source=/dev/null
    source "${HOME}/.cargo/env"

    # Install cargo package
    if cmdexists cargo; then
        declare -A CARGO_GIT_PKGS=()
        declare -A CARGO_PKGS=(
            ["ripgrep"]="14.1.1"
            ["bottom"]="0.9.6"
            ["fd-find"]="10.1.0"
            ["stylua"]="0.20.0"
            ["du-dust"]="1.1.1"
            ["git-delta"]="0.17.0"
            ["alacritty"]="0.13.2"
            ["zoxide"]="0.9.5"
            ["gitui"]="0.26.3"
            ["eza"]="0.19.0"
            ["bat"]="0.24.0"
        )

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
