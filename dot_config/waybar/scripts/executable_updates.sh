#!/usr/bin/env bash

check() {
    command -v "$1" 1> /dev/null
}

notify() {
    check notify-send && {
        notify-send "$@"
        return
    }
    echo "$@"
}

stringToLen() {
    STRING="$1"
    LEN="$2"
    if [ ${#STRING} -gt "$LEN" ]; then
        echo "${STRING:0:$((LEN - 2))}.."
    else
        printf "%-20s" "$STRING"
    fi
}

OS_RELEASE="/usr/lib/os-release"
if [[ ! -f "$OS_RELEASE" ]]; then
    echo "{\"text\":\"ERR\",\"tooltip\":\"/usr/lib/os-release does not exist\"}" | jq .
    exit 1
fi

DISTRIB=$(grep ID_LIKE $OS_RELEASE | cut -d'=' -f2)
case "$DISTRIB" in
"arch")
    check checkupdates || {
        echo "{\"text\":\"ERR\",\"tooltip\":\"checkupdates is not installed\"}" | jq .
        exit 1
    }
    IFS=$'\n'$'\r'

    killall -q checkupdates
    mapfile -t updates < <(checkupdates)

    nbUpdates=${#updates[@]}

    tooltip="<b>$nbUpdates  updates</b>\n"
    tooltip+=" <b>$(stringToLen "PkgName" 20) $(stringToLen "PrevVersion" 20) $(stringToLen "NextVersion" 20)</b>\n"

    for i in "${updates[@]}"; do
        update="$(stringToLen "$(echo "$i" | awk '{print $1}')" 20)"
        prev="$(stringToLen "$(echo "$i" | awk '{print $2}')" 20)"
        next="$(stringToLen "$(echo "$i" | awk '{print $4}')" 20)" # skipping '->' string
        tooltip+="<b> $update </b>$prev $next\n"
    done
    tooltip=${tooltip::-2}
    ;;
"debian")
    check apt || {
        echo "{\"text\":\"ERR\",\"tooltip\":\"apt-list is not installed\"}" | jq .
        exit 1
    }
    IFS=$'\n'$'\r'

    killall -q apt
    mapfile -t updates < <(apt list --upgradable)

    nbUpdates=${#updates[@]}

    tooltip="<b>$nbUpdates  updates</b>\n"
    tooltip+=" <b>$(stringToLen "PkgName" 20) $(stringToLen "PrevVersion" 20) $(stringToLen "NextVersion" 20)</b>\n"

    for i in "${updates[@]}"; do
        update="$(stringToLen "$(echo "$i" | awk '{print $1}')" 20)"
        prev="$(stringToLen "$(echo "$i" | awk '{print $3}')" 20)"
        next="$(stringToLen "$(echo "$i" | awk '{print $7}')" 20)" # skipping '->' string
        tooltip+="<b> $update </b>$prev $next\n"
    done
    tooltip=${tooltip::-2}
    ;;
*)
    exit 0
    ;;
esac

[ "$nbUpdates" -eq 0 ] && nbUpdates="" || nbUpdates="  $nbUpdates"
echo "{ \"text\": \"$nbUpdates\", \"tooltip\": \"$tooltip\"}"

# vim: ft=sh
