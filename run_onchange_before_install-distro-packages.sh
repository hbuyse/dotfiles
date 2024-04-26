#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

if [ "${CHEZMOI_UID}" -eq 0 ]; then
    readonly SUDO=""
else
    readonly SUDO="sudo"
fi

if [ -n "${SUDO}" ]; then
    prompt "Asking for 'sudo' rights: "
    sudo -p "" -v
    display_ko_ok ${?}
fi

case "${OS}-${ID}" in
"linux-manjaro" | "linux-arch")
    # Install my package
    install_packages \
        chezmoi age \
        firefox \
        i3-wm feh autorandr rofi npm xautolock polybar \
        zsh fzf tmux npm \
        clang git git-lfs curl htop \
        python-pip python-virtualenv python-virtualenvwrapper \
        base-devel openssl zlib xz tk \
        neovim \
        git-delta \
        libnotify \
        bitwarden \
        bat \
        lua-language-server \
        texlab shellcheck shfmt \
        nextcloud-client \
        direnv
    ;;

"linux-ubuntu")
    prompt "Update mirrors to latest update: "
    ${SUDO} apt-get update --quiet --quiet
    display_ko_ok $?

    # Add PPAs
    echo "Installing PPAs"
    for i in "git-core/ppa" "yubico/stable" "regolith-linux/stable" "hsheth2/ppa"; do
        prompt "- ${i}:"
        if grep -riq "${i}" "/etc/apt/sources.list.d"; then
            display_already_installed
        else
            ${SUDO} add-apt-repository -ny ppa:${i}
            display_ko_ok $?
        fi
    done

    # Install packages (nodejs = node + npm)
    NODE_MAJOR=20
    prompt "Installing Node JS ${NODE_MAJOR} (LTS) repo" && echo
    install_packages ca-certificates curl gnupg
    ${SUDO} mkdir -p /etc/apt/keyrings

    prompt "- Downloading GPG key: "
    curl -fsSL "https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key" | ${SUDO} gpg --yes --dearmor -o "/etc/apt/keyrings/nodesource.gpg"
    display_ko_ok $?

    prompt "- Adding repo: "
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | sudo tee "/etc/apt/sources.list.d/nodesource.list" >"/dev/null"
    display_ko_ok $?

    # Refresh packages list
    prompt "Updating packages list: "
    ${SUDO} apt-get update --quiet --quiet
    display_ko_ok $?

    install_packages \
        yubikey-manager \
        yubikey-personalization-gui \
        libpam-yubico \
        libpam-u2f \
        meld \
        git git-lfs \
        nodejs \
        i3-gaps \
        python3-pip \
        python3-dev \
        zsh \
        curl \
        cava \
        tshark \
        bsdmainutils

    # Install dunst
    DUNST_VERSION="1.9.2"
    prompt "Installing dunst v${DUNST_VERSION}: "
    if cmdexists dunst || ! dunst --version | grep -q ${DUNST_VERSION}; then
        display_already_installed
    else
        # Dunst dependencies
        echo
        prompt "- Installing dependencies: "
        install_packages \
            libdbus-1-dev \
            libx11-dev \
            libxinerama-dev \
            libxrandr-dev \
            libxss-dev \
            libglib2.0-dev \
            libpango1.0-dev \
            libgtk-3-dev \
            libxdg-basedir-dev
        display_ko_ok $?

        prompt "- Downloading and extracting source code:"
        curl --location --silent "https://github.com/dunst-project/dunst/archive/refs/tags/v${DUNST_VERSION}.tar.gz" | tar -xz -C /tmp -f -
        display_ko_ok $?

        prompt "- Compiling source code: "
        make -C /tmp/dunst-${DUNST_VERSION} PREFIX="${HOME}/.local" install
        display_ko_ok $?

        rm -rf /tmp/dunst-${DUNST_VERSION}
    fi

    # Install i3lock color
    I3LOCK_COLOR_VERSION="2.13.c.4"
    prompt "Installing i3lock-color v${I3LOCK_COLOR_VERSION}: "
    if cmdexists i3lock && i3lock --version 2>&1 | grep -q ${I3LOCK_COLOR_VERSION}; then
        display_already_installed
    else
        # Install i3lock-color
        prompt "- Installing dependencies: "
        install_packages \
            autoconf \
            gcc \
            make \
            pkg-config \
            libpam0g-dev \
            libcairo2-dev \
            libfontconfig1-dev \
            libxcb-composite0-dev \
            libev-dev \
            libx11-xcb-dev \
            libxcb-xkb-dev \
            libxcb-xinerama0-dev \
            libxcb-randr0-dev \
            libxcb-image0-dev \
            libxcb-util-dev \
            libxcb-xrm-dev \
            libxkbcommon-dev \
            libxkbcommon-x11-dev \
            libjpeg-dev
        display_ko_ok $?

        prompt "- Downloading and extracting source code:"
        curl --location --silent "https://github.com/Raymo111/i3lock-color/archive/refs/tags/${I3LOCK_COLOR_VERSION}.tar.gz" | tar -xz -C /tmp -f -
        display_ko_ok $?

        prompt "- Compiling source code: "
        autoreconf -fiv /tmp/i3lock-color-${I3LOCK_COLOR_VERSION}
        mkdir -p /tmp/i3lock-color-${I3LOCK_COLOR_VERSION}/build
        (
            cd "/tmp/i3lock-color-${I3LOCK_COLOR_VERSION}/build" || exit
            "/tmp/i3lock-color-${I3LOCK_COLOR_VERSION}/configure" --disable-sanitizers --prefix="${HOME}/.local"
        )
        make -C /tmp/i3lock-color-${I3LOCK_COLOR_VERSION}/build PREFIX="${HOME}/.local" install
        display_ko_ok $?

        rm -rf /tmp/i3lock-color-${I3LOCK_COLOR_VERSION}
    fi
    ;;

"freebsd-freebsd")
    # Copy /etc/pkg/FreeBSD.conf and change to https
    FREEBSD_PKG_REPOS="/usr/local/etc/pkg/repos"
    if [ ! -f ${FREEBSD_PKG_REPOS}/FreeBSD.conf ]; then
        prompt "Copy pkg config to ${FREEBSD_PKG_REPOS}/FreeBSD.conf: "
        ${SUDO} mkdir -p ${FREEBSD_PKG_REPOS}
        ${SUDO} cp /etc/pkg/FreeBSD.conf ${FREEBSD_PKG_REPOS}/FreeBSD.conf
        display_ko_ok $?
        prompt "Change URL to HTTPS: "
        ${SUDO} sed -i -e 's/pkg\+http:/pkg\+https:/' -e 's/latest/quaterly/' ${FREEBSD_PKG_REPOS}/FreeBSD.conf
        display_ko_ok $?
    fi

    # Install packages
    install_packages \
        age \
        chezmoi \
        termshark \
        tree \
        git-lfs \
        npm \
        ripgrep \
        fd-find \
        py39-pip \
        zsh \
        curl \
        rust-analyzer \
        wget \
        pkgconf \
        gmake \
        cmake \
        fzf \
        libtool \
        gettext \
        neovim \
        npm \
        direnv \
        git-delta
    ;;
*)
    echo "Unsupported distribution '${ID}' (based on OS '${OS}')"
    ;;
esac

# Check ZSH is my shell
if ! grep -i "$USER" /etc/passwd | cut -d: -f 7 | grep -q zsh; then
    prompt "Changing shell to $(which zsh)"
    chsh -s "$(which zsh)"
fi

# vim: set ts=4 sw=4 tw=0 et ft=sh :
