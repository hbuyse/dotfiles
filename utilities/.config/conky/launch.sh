#! /usr/bin/env bash

readonly DAEMON="conky"
readonly CONKY_CONFIG_FOLDER="${HOME}/.config/conky"
readonly TMP_FOLDER="/tmp/conky"
readonly DATE_TIME_CONFIG="${TMP_FOLDER}/conkyrc.date.time"
readonly PROC_CONFIG="${TMP_FOLDER}/conkyrc.proc.mem"
readonly CONKIES=("${DATE_TIME_CONFIG}" "${PROC_CONFIG}")

# Check that the daemon command exist
if ! command -v ${DAEMON} > "/dev/null"; then
	echo "Conky not found. Exiting"
	exit 1
fi

# Kill all processes even if the daemon binary does not exist
# The daemon may have been uninstalled
killall -q -9 ${DAEMON}

# Create log folder
mkdir -p ${TMP_FOLDER}

# Create config date time
head -$(($(wc -l ${CONKY_CONFIG_FOLDER}/conkyrc.date.time | cut -d' ' -f1) - 2)) ${CONKY_CONFIG_FOLDER}/conkyrc.date.time > ${DATE_TIME_CONFIG}
while read mountpoint
do
    echo "\$font\${color}$mountpoint:\${alignr}\${color2}\${fs_used_perc $mountpoint} % - \${fs_used $mountpoint} / \${fs_size $mountpoint}" >> ${DATE_TIME_CONFIG}
done < <(mount | grep -E ^/dev | awk '{print $3}' | sort)
tail -2 ${CONKY_CONFIG_FOLDER}/conkyrc.date.time >> ${DATE_TIME_CONFIG}

# Create config processes mem usage
SCREEN_WIDTH=$(xrandr | grep " connected primary " | awk -F '[ x+]' '{print $5}')
sed -e "s/CONKY_GAP_Y/$((SCREEN_WIDTH-230))/g" "${CONKY_CONFIG_FOLDER}/conkyrc.proc.mem.in" > ${PROC_CONFIG}

# Launch conkies
for conky_conf in ${CONKIES[*]}; do
	${DAEMON} -c "${conky_conf}" -d > "$(mktemp -p ${TMP_FOLDER} conky.XXXXXXXXXX.log)" 2>&1
done
# vim: set ts=4 sw=4 tw=0 et ft=sh :
