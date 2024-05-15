#!/usr/bin/env sh

status() {
    pgrep -f "systemd-inhibit --what=idle" > /dev/null 2>&1
    return $?
}

send_signal() {
    pkill -x -SIGRTMIN+15 'waybar'
}

inhibit() {
    systemd-inhibit --what=idle --who=swayidle-inhibit --why=commanded --mode=block sleep "$1" &
    send_signal
}

case $1'' in
'interactive')
    MINUTES=$(printf "1\n10\n15\n20\n30\n45\n60\n90\n120" | wofi --dmenu --prompt="Select how many minutes to inhibit idle:")
    inhibit $((MINUTES * 60))
    ;;
'off')
    pkill -f "systemd-inhibit --what=idle" || true
    send_signal
    ;;
'check')
    command -v systemd-inhibit && command -v wofi
    exit $?
    ;;
esac

#Returns data for Waybar
if status; then
    class="activated"
    text="Inhibiting idle (Mid click to clear)"
else
    class="deactivated"
    text="Idle not inhibited"
fi

printf '{"alt":"%s", "class": "%s", "tooltip":"%s"}\n' "$class" "$class" "$text"
