#! /usr/bin/env bash

# Load the shell lib
. "${CHEZMOI_WORKING_TREE}/utils.sh"

display_info "${0}"

if [ "${CHEZMOI_UID}" -eq 0 ]; then
    readonly SUDO=""
else
    readonly SUDO="sudo"
fi

LSP_SERVERS_AS_PKG=()
declare -A LSP_SERVERS_AS_NPM=()

case "${OS}-${ID}" in
"linux-manjaro" | "linux-arch")
    LSP_SERVERS_AS_PKG+=("clang") # clangd
    LSP_SERVERS_AS_PKG+=("lua-language-server")
    LSP_SERVERS_AS_PKG+=("bash-language-server")
    LSP_SERVERS_AS_PKG+=("pyright")
    LSP_SERVERS_AS_PKG+=("texlab")
    LSP_SERVERS_AS_PKG+=("typescript-language-server")
    LSP_SERVERS_AS_PKG+=("vscode-css-languageserver")
    LSP_SERVERS_AS_PKG+=("vscode-html-languageserver")
    LSP_SERVERS_AS_PKG+=("vscode-json-languageserver")
    LSP_SERVERS_AS_PKG+=("vscode-markdown-languageserver")
    LSP_SERVERS_AS_PKG+=("yaml-language-server")
    LSP_SERVERS_AS_PKG+=("rust-analyzer")

    ;;
"freebsd-freebsd")
    LSP_SERVERS_AS_PKG+=("llvm")
    LSP_SERVERS_AS_PKG+=("rust-analyzer")
    LSP_SERVERS_AS_PKG+=("texlab")
    LSP_SERVERS_AS_NPM["bash-language-server"]="5.1.2"
    LSP_SERVERS_AS_NPM["pyright"]="1.1.360"
    LSP_SERVERS_AS_NPM["typescript-language-server"]="4.3.3"
    LSP_SERVERS_AS_NPM["vscode-langservers-extracted"]="4.8.0"
    LSP_SERVERS_AS_NPM["yaml-language-server"]="1.14.0"
    # Lua language server should be installed using externals
    ;;
"linux-ubuntu")
    LSP_SERVERS_AS_PKG+=("clangd") # clangd
    # texlab and lua-language-server are installed throught the externals
    # LSP_SERVERS_AS_PKG+=("texlab")
    # LSP_SERVERS_AS_PKG+=("lua-language-server")
    LSP_SERVERS_AS_NPM["bash-language-server"]="5.1.2"
    LSP_SERVERS_AS_NPM["pyright"]="1.1.360"
    LSP_SERVERS_AS_NPM["typescript-language-server"]="4.3.3"
    LSP_SERVERS_AS_NPM["vscode-langservers-extracted"]="4.8.0"
    LSP_SERVERS_AS_NPM["yaml-language-server"]="1.14.0"

    # Install rust-analyzer
    if [[ "${OS}" == "linux" ]]; then
        curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - >"${HOME}/.local/bin/rust-analyzer"
        chmod +x "${HOME}/.local/bin/rust-analyzer"
    fi
    ;;
*)
    echo "Unsupported distribution '${ID}' (based on OS '${OS}')"
    ;;
esac

if [ ${#LSP_SERVERS_AS_PKG[@]} -gt 0 ] && [ -n "${SUDO}" ]; then
    prompt "Asking for 'sudo' rights: "
    sudo -p "" -v
    display_ko_ok ${?}

    install_packages "${LSP_SERVERS[@]}"
fi

for pkg in "${!LSP_SERVERS_AS_NPM[@]}"; do
    npm_install "${pkg}" "${LSP_SERVERS_AS_NPM[${pkg}]}"
done
