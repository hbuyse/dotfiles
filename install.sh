#! /usr/bin/env bash

DOTFILES_PATH="$(dirname "$(realpath "${0}")")"

init_wallpapers() {
	echo -ne "- \e[33mPull wallpapers...\e[0m"
	git --work-tree="${DOTFILES_PATH}" --git-dir="${DOTFILES_PATH}/.git" lfs pull
	echo -e "\e[32m done\e[0m"
}

init_stow() {
	local stow_param=("${@}")
	local stow_array=(devtools gifs git neovim shells terminals utilities wallpapers wms X)

	echo -ne "- \e[33mStowing...\e[0m"
	for val in ${stow_array[*]}; do
		if [ "${#stow_param[*]}" -eq 0 ]; then
			stow -t "${HOME}" -d "${DOTFILES_PATH}" "${val}"
		else
			# shellcheck disable=SC2086
			stow ${stow_param[*]} -t "${HOME}" -d "${DOTFILES_PATH}" "${val}"
		fi
	done
	echo -e "\e[32m done\e[0m"
}

install_nerd_font() {
	local font="${1}"
	local NERD_FONTS_DIR="${DOTFILES_PATH}/nerd-fonts"

	echo -ne "- \e[33mInstalling ${font} font...\e[0m"

	# Cannot download if git version inferior to 2.26
	if [ "$(git --version | cut -d'.' -f2)" -lt 2 ] || [ "$(git --version | cut -d'.' -f2)" -lt 26 ]; then
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

	echo -e "\e[32m done\e[0m"
}

finalize_git() {
	if [ ! -f "${HOME}/.gituser" ]; then
		echo -e "\e[31mDo not forget to add your user.name and your user.email into the file ${HOME}/.gituser\e[0m" 1>&2
	fi
}


init_stow "$@"
init_wallpapers
finalize_git
install_nerd_font "Hack"
