#! /usr/bin/env bash

readonly RED="\e[1;31m"
readonly GREEN="\e[1;32m"
readonly YELLOW="\e[1;33m"
readonly DEFAULT="\e[0m"

readonly OS="${CHEZMOI_OS}"
readonly ID="${CHEZMOI_OS_RELEASE_ID}"
readonly IDLIKE="${CHEZMOI_OS_RELEASE_ID_LIKE}"

if [ "${CHEZMOI_UID}" -eq 0 ]; then
    readonly SUDO=""
else
    readonly SUDO="sudo"
fi

function check_sudo() {
    if [ -n "${SUDO}" ]; then
        echo -en "Asking for 'sudo' rights: "
        sudo -p "" -v && echo -e "${GREEN}OK${DEFAULT}" || echo -e "${RED}KO${DEFAULT}"
    fi
}

function prompt() {
    echo -en "$*: "
}

function display_already_installed() {
    echo -e "${YELLOW}already installed${DEFAULT}"
}

function display_ko_ok() {
    [ "${1}" -eq 0 ] && echo -e "${GREEN}OK${DEFAULT}" || echo -e "${RED}KO${DEFAULT}"
}

function cmdexists() {
    command -v "$1" > /dev/null && return 0 || return 1
}

function display_info() {
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
function aur_install_packages() {
    local packages_to_install=("$@")
    local packages_not_installed=()
    local install_cmd=""

    if [ "${OS}-${ID}" = "linux-arch" ]; then
        install_packages \
            git \
            base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        makepkg --syncdeps --install --needed --noconfirm --nocheck --dir /tmp/yay
        rm -rf /tmp/yay
    fi

    # Get the command to install package and check that package is installed
    case "${OS}-${ID}" in
    "linux-manjaro" | "linux-arch")
        install_cmd="yay --sync --refresh --refresh --needed --answerclean NotInstalled --answerdiff NotInstalled"
        # Check that package is installed
        for pkg in "${packages_to_install[@]}"; do
            # Check if not already installed
            if ! yay --query --search --quiet "${pkg}" | grep -qw "${pkg}" 2>&1; then
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
        check_sudo

        prompt "Installing ${packages_not_installed[*]} using AUR"
        # shellcheck disable=SC2086
        ${SUDO} ${install_cmd} "${packages_not_installed[@]}"
        display_ko_ok $?
    fi
}

# Install packages based on the OS.
# Check that the package is installed before installing it.
function install_packages() {
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

    "linux-opensuse-tumbleweed")
        install_cmd="zypper --quiet --non-interactive install"
        # Check that package is installed
        for pkg in "${packages_to_install[@]}"; do
            # Check if already installed
            if ! zypper --quiet search --installed-only --match-exact ${pkg} > /dev/null 2>&1; then
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
        check_sudo

        prompt "Installing ${packages_not_installed[*]}"
        # shellcheck disable=SC2086
        ${SUDO} ${install_cmd} "${packages_not_installed[@]}"
        display_ko_ok $?
    fi
}

function npm_install() {
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

function cargo_install() {
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

function cargo_git_install() {
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
            prompt "Installing '${package} ${version}' using cargo"
        fi

        if [ -n "${features}" ]; then
            args=("--features" "${features}")
        fi

        cargo install --quiet --locked --jobs=4 --tag="${version}" "${args[@]}" --git "${git_uri}"
        display_ko_ok ${?}
    fi
}

function pip_install() {
    local package="${1}"
    local version="${2}"

    if python3 -m pip freeze --user | grep -q "${package}==${version}"; then
        prompt "Installing '${package} v${version}' using pip"
        display_already_installed
    else
        local upgrade_opt=""
        if python3 -m pip freeze --user | grep -q "${package}"; then
            prompt "Updating '${package}' to version '${version}' using pip"
            upgrade_opt="--upgrade"
        else
            prompt "Installing '${package} v${version}' using pip"
        fi
        python3 -m pip install --quiet --user ${upgrade_opt} "${package}==${version}"
        display_ko_ok ${?}
    fi
}
