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
    # Display some information about the install
    echo "==================================="
    echo "Script: ${1}"
    echo "-----------------------------------"
    echo "Operating System: ${OS}"
    echo "Distribution ID: ${ID}"
    echo "Distribution IDLike: ${IDLIKE}"
    echo "User: ${USER}"
    echo "==================================="
}

# Install packages based on the OS.
# Check that the package is installed before installing it.
install_packages() {
    local packages_to_install=("$@")
    local packages_not_installed=()
    local install_cmd=""

    # Get the command to install package and check that package is installed
    case "${OS}-${ID}" in
    "linux-manjaro" | "linux-arch")
        install_cmd="pacman --sync --refresh --refresh --sysupgrade --needed --noconfirm"
        # Check that package is installed
        for pkg in "${packages_to_install[@]}"; do
            # Check if not already installed
            if ! pacman --query --search --quiet "${pkg}" | grep -qw "${pkg}" 2>&1; then
                packages_not_installed+=("${pkg}")
            fi
        done
        ;;

    "linux-ubuntu")
        install_cmd="apt-get install --assume-yes --quiet"
        # Check that package is installed
        for pkg in "${packages_to_install[@]}"; do
            # Check if not already installed
            if ! dpkg --get-selections | grep -w "${pkg}" | awk '{ print $2 }' | grep -q -w 'install'; then
                packages_not_installed+=("${pkg}")
            fi
        done
        ;;

    "freebsd-freebsd")
        install_cmd="pkg install --automatic --yes"
        # Check that package is installed
        for pkg in "${packages_to_install[@]}"; do
            # Check if already installed
            if ! pkg info | grep -qw "${pkg}"; then
                packages_not_installed+=("${pkg}")
            fi
        done
        ;;

    *)
        echo "Unsupported distribution '${ID}' (based on OS '${OS}')"
        return
        ;;
    esac

    # Install only the packages that are not already installed
    if [ ${#packages_not_installed[@]} -ne 0 ]; then
        prompt "Installing ${packages_not_installed[*]}: "
        # shellcheck disable=SC2086
        "${SUDO}" ${install_cmd} "${packages_not_installed[@]}"
        display_ko_ok $?
    fi
}

npm_install() {
    local package="${1}"
    local version="${2}"
    local pkg_and_version="${package}@${version}"

    if [ -n "$(npm list --location=global -p "${pkg_and_version}")" ]; then
        prompt "Installing '${pkg_and_version}' using npm"
        display_already_installed
    elif [ -n "$(npm list --location=global -p "${package}")" ]; then
        prompt "Updating '${package}' to version '${version}' using npm"
        npm install --silent --location=global "${pkg_and_version}"
        local err=${?}
        if [ ${err} -eq 0 ]; then
            prompt "Updating '${package}' to version '${version}' using npm"
        fi
        display_ko_ok ${err}
    else
        prompt "Installing '${package} v${version}' using npm"
        npm install --silent --location=global "${pkg_and_version}"
        local err=${?}
        prompt "Installing '${package}' using npm"
        display_ko_ok ${err}
    fi
}

cargo_install() {
    local package="${1}"
    local version_and_features="${2}"
    local version
    local features
    local args

    if ! cmdexists cargo; then
        # shellcheck source=/dev/null
        source "${HOME}/.cargo/env"
    fi

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

        cargo install --quiet --locked --jobs=4 --version="${version}" "${args[@]}" "${package}"
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

    if ! cmdexists cargo; then
        # shellcheck source=/dev/null
        source "${HOME}/.cargo/env"
    fi

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

        cargo install --quiet --locked --jobs=4 --tag="v${version}" "${args[@]}" --git "${git_uri}"
        display_ko_ok ${?}
    fi
}

pip_install() {
    local package="${1}"
    local version="${2}"

    if "${PIP_PATH}" freeze --local | grep -q "${package}==${version}"; then
        prompt "Installing '${package} v${version}' using pip"
        display_already_installed
    else
        local upgrade_opt=""
        if "${PIP_PATH}" freeze --local | grep -q "${package}"; then
            prompt "Updating '${package}' to version '${version}' using pip"
            upgrade_opt="--upgrade"
        else
            prompt "Installing '${package} v${version}' using pip"
        fi
        "${PIP_PATH}" install --quiet --user ${upgrade_opt} "${package}==${version}"
        display_ko_ok ${?}
    fi
}
