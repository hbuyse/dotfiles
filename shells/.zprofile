
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

# set path so it includes pyenv
if [ -d "$HOME/.pyenv" ]; then
	export PATH="$HOME/.pyenv/bin:$PATH"
	eval "$(pyenv init --path)"
fi

# set path so it includes npm
if [ -d "$HOME/.npm-packages/bin" ]; then
	export PATH="$HOME/.npm-packages/bin:$PATH"
fi

# set path so it includes cargo binaries (Rust)
if [ -f "$HOME/.cargo/env" ]; then
	. "$HOME/.cargo/env"
fi
