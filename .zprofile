
# set path so it includes pyenv
if [ -d "$HOME/.pyenv" ]; then
	export PATH="$HOME/.pyenv/bin:$PATH"
	eval "$(pyenv init --path)"
fi

if [ -d "$HOME/.npm-packages/bin" ]; then
	export PATH="$HOME/.npm-packages/bin:$PATH"
fi
