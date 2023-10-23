#!/usr/bin/env bash

OS_RELEASE="/usr/lib/os-release"
LIST=()

if [[ -f "$OS_RELEASE" ]]; then
    DISTRIB=$(grep ID_LIKE $OS_RELEASE | cut -d'=' -f2)
    case "$DISTRIB" in
    arch)
        while read -r line; do
            LIST+=("${line}")
        done < <(checkupdates 2> /dev/null | awk '{print $1}')
        ;;
    debian)
        while read -r line; do
            LIST+=("${line}")
        done < <(apt list --upgradable 2> /dev/null | grep upgradable | awk -F'/' '{print $1}')
        ;;
    *)
        exit 0
        ;;
    esac
fi

# no output
if [[ "${#LIST[*]}" -le 0 ]]; then
    echo
    exit 0
fi

# Display
if [[ "${1}" == "notify" ]] && command -v notify-send > /dev/null 2>&1; then
    notify-send "Updates available" "$(
        IFS=$'\n'
        echo "${LIST[*]}"
        IFS=$' \t\n'
    )"
else
    if [[ ${#LIST[*]} -gt 0 ]]; then
        echo " ${#LIST[*]}"
    else
        echo ""
    fi
fi

# vim: set ts=4 sw=4 tw=0 et ft=sh :
