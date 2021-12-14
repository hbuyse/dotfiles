#! /usr/bin/env bash

DOTFILES_PATH="$(dirname "$(realpath "${0}")")"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"

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

install_pip() {
	local pip_url="https://bootstrap.pypa.io/get-pip.py"
	echo -ne "- ${YELLOW}Installing pip...${RESET}"

	if command -v pip > /dev/null; then
		echo -e "${GREEN} already installed${RESET}"
		return
	fi

	if ! command -v python > /dev/null; then
		echo -e "\n${RED}To install pip, you need 'python'${RESET}" 1>&2
		return
	fi

	# Download get-pip.py if python < 3.4
	if [ "$(python --version | cut -d'.' -f1 | cut -d' ' -f2)" -lt 3 ] || [ "$(python --version | cut -d'.' -f2)" -lt 4 ]; then
		# Get a filepath but do not create the file (-u is marked as 'unsafe' in the man)
		local get_pip_filepath=$(mktemp -u)

		if command -v curl > /dev/null; then
			curl -qsSL "${get_pip_filepath}" -o "${get_pip_filepath}"
		elif command -v wget > /dev/null; then
			wget -q --no-check-certificate "${get_pip_filepath}" -O "${get_pip_filepath}"
		else
			echo -e "\n${RED}To install pip, you need either 'curl' or 'wget'${RESET}" 1>&2
			return
		fi

		if [ ! -f "${get_pip_filepath}" ]; then
			echo -e "\n${RED}Error while downloading 'get-pip.py'${RESET}" 1>&2
			return
		fi

		python "${get_pip_filepath}" --quiet

		# Remove the temporary file
		rm -f "${get_pip_filepath}"
	else
		if ! python -m ensurepip --upgrade --user > /dev/null; then
			echo -e "\n${RED}Error while running 'python -m ensurepip --user --upgrade'${RESET}" 1>&2
		fi
	fi

	echo -e "${GREEN} done${RESET}"
}

polybar_venv() {
	echo -ne "- ${YELLOW}Installing virtualenv for polybar...${RESET}"

	local script_path="$HOME/.config/polybar/scripts"

    if ! command -v python3 > /dev/null; then
		echo -e "${RED}To install virtualenv for polybar scripts, you need to install 'python3'${RESET}" 1>&2
		return
	fi

    if ! command -v virtualenv > /dev/null; then
		echo -e "${RED}To install virtualenv for polybar scripts, you need to install 'virtualenv'${RESET}" 1>&2
		echo -e "${RED}    pip install --user virtualenv${RESET}" 1>&2
		return
	fi

	if [ ! -f "${script_path}/.venv/bin/python3" ]; then
		virtualenv -p $(which python3) "${script_path}/.venv"
		return
	fi

	"${script_path}/.venv/bin/pip" install -q -r "${script_path}/requirements.txt"

	echo -e "${GREEN} done${RESET}"
}

install_oh_my_zsh() {
	echo -ne "- ${YELLOW}Installing oh-my-zsh...${RESET}"
	local

	if [ -d "${OH_MY_ZSH_DIR}" ]; then
		echo -e "${GREEN} already installed${RESET}"
		return
	fi

	if command -v curl > /dev/null; then
		ZSH="${OH_MY_ZSH_DIR}" sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	elif command -v wget > /dev/null; then
		ZSH="${OH_MY_ZSH_DIR}" sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
	else
		echo -e "\n${RED}To install oh-my-zsh, you need either 'curl' or 'wget'${RESET}" 1>&2
		return
	fi

	echo -e "${GREEN} done${RESET}"
}

install_powerlevel10k() {
	local install_dir="${OH_MY_ZSH_DIR}/custom/themes/powerlevel10k"

	echo -ne "- ${YELLOW}Installing powerlevel10k...${RESET}"

	if [ ! -d "${OH_MY_ZSH_DIR}" ]; then
		echo -e "\n${RED}oh-my-zsh is not installed. Install it before continuing${RESET}" 1>&2
		return
	fi

	if [ -d "${install_dir}" ]; then
		echo -e "${GREEN} already installed${RESET}"
		return
	fi

	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${install_dir}

	echo -e "${GREEN} done${RESET}"
}

init_stow "$@"
init_wallpapers

install_pip

polybar_venv

install_nerd_font "Hack"
install_oh_my_zsh
install_powerlevel10k

# Always at the end to see it
finalize_git
