#! /usr/bin/env bash

SCRIPT_PATH="$(dirname $(realpath ${0}))"
STOW_PARAM=${@}
STOW_ARRAY=(devtools gifs git neovim shells terminals utilities wallpapers wms X)

for val in ${STOW_ARRAY[*]}; do
	stow $STOW_PARAM -t ${HOME} -d ${SCRIPT_PATH} ${val}
done

if [ ! -f "$HOME/.gituser" ]; then
	echo "Do not forget to add your user.name and your user.email into the file $HOME/.gituser" 1>&2
fi

git --work-tree=${SCRIPT_PATH} --git-dir=${SCRIPT_PATH}/.git lfs pull
