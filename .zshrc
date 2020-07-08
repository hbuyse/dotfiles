HOSTNAME="$(hostname)"

if [[ $HOSTNAME == "T480" || $HOSTNAME == "CG8250" ]]; then
	source $HOME/.zshrc.home
else
	source $HOME/.zshrc.work
fi
