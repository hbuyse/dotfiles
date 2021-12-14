#! /usr/bin/env bash

DOTFILES_PATH="$(dirname "$(realpath "${0}")")"

RED=$(printf '\033[31m')
GREEN=$(printf '\033[32m')
YELLOW=$(printf '\033[33m')
BLUE=$(printf '\033[34m')
BOLD=$(printf '\033[1m')
RESET=$(printf '\033[m')

init_wallpapers() {
	echo -ne "- ${YELLOW}Pull wallpapers...${RESET}"
	git --work-tree="${DOTFILES_PATH}" --git-dir="${DOTFILES_PATH}/.git" lfs pull
	echo -e "${GREEN} done${RESET}"
}

init_stow() {
	local stow_param=("${@}")
	local stow_array=(devtools gifs git neovim shells terminals utilities wallpapers wms X)

	echo -ne "- ${YELLOW}Stowing...${RESET}"
	for val in ${stow_array[*]}; do
		if [ "${#stow_param[*]}" -eq 0 ]; then
			stow -t "${HOME}" -d "${DOTFILES_PATH}" "${val}"
		else
			# shellcheck disable=SC2086
			stow ${stow_param[*]} -t "${HOME}" -d "${DOTFILES_PATH}" "${val}"
		fi
	done
	echo -e "${GREEN} done${RESET}"
}

install_nerd_font() {
	local font="${1}"
	local NERD_FONTS_DIR="${DOTFILES_PATH}/nerd-fonts"

	echo -ne "- ${YELLOW}Installing ${font} font...${RESET}"

	# Cannot download if git version inferior to 2.26
	if [ "$(git --version | cut -d'.' -f1 | cut -d' ' -f3)" -lt 2 ] || [ "$(git --version | cut -d'.' -f2)" -lt 26 ]; then
		echo -e "\nCannot install Nerd Font '${font}': git version should be superior than 2.26" 1>&2
		return
	fi

	# Clone repo only if necessary
	if [ ! -d "${NERD_FONTS_DIR}" ]; then
		git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts "${NERD_FONTS_DIR}" > /dev/null 2>&1
	fi

	# checkout font only if needed
	if [ ! -d "${NERD_FONTS_DIR}/patched-fonts/${font}" ]; then
		git --git-dir="${NERD_FONTS_DIR}/.git" --work-tree="${NERD_FONTS_DIR}" sparse-checkout add "patched-fonts/${font}" > /dev/null 2>&1
	fi

	# Install the fonts
	"${DOTFILES_PATH}/nerd-fonts/install.sh" -q "${font}"

	echo -e "${GREEN} done${RESET}"
}

finalize_git() {
	if [ ! -f "${HOME}/.gituser" ]; then
		echo -e "${RED}Do not forget to add your user.name and your user.email into the file ${HOME}/.gituser${RESET}" 1>&2
	fi
}


init_stow "$@"
init_wallpapers
finalize_git
install_nerd_font "Hack"
