#!/usr/bin/env bash

OS_RELEASE="/usr/lib/os-release"

if [[ -f "$OS_RELEASE" ]]; then
    DISTRIB=$(grep ID_LIKE $OS_RELEASE | cut -d'=' -f2)
    case "$DISTRIB" in
        arch)
            updates=$(checkupdates 2> /dev/null | wc -l )
            ;;
        debian)
            updates=$(apt list --upgradable 2> /dev/null | grep -c upgradable);
            ;;
    esac
fi

if [[ $updates -gt 0 ]]; then
    echo " $updates"
else
    echo ""
fi
# vim: set ts=4 sw=4 tw=0 et ft=sh :
