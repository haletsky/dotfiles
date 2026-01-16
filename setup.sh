#! /bin/bash

DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_REPO_SSH="git@github.com:haletsky/dotfiles.git"
DOTFILES_REPO_HTTPS="https://github.com/haletsky/dotfiles.git"
OS_NAME="$(uname -s)"

download_file() {
	local url="$1"
	local dest="$2"

	if command -v curl >/dev/null 2>&1; then
		curl -fLo "$dest" --create-dirs "$url"
	elif command -v wget >/dev/null 2>&1; then
		mkdir -p "$(dirname "$dest")"
		wget -qO "$dest" "$url"
	else
		echo "curl or wget not found (cannot download $url)."
		return 1
	fi
}

run_remote_script() {
	local url="$1"
	local interpreter="${2:-sh}"
	local tmpfile

	tmpfile="$(mktemp)"
	if command -v curl >/dev/null 2>&1; then
		if ! curl -fsSL "$url" -o "$tmpfile"; then
			echo "Failed to download $url."
			rm -f "$tmpfile"
			return 1
		fi
	elif command -v wget >/dev/null 2>&1; then
		if ! wget -qO "$tmpfile" "$url"; then
			echo "Failed to download $url."
			rm -f "$tmpfile"
			return 1
		fi
	else
		echo "curl or wget not found (cannot download $url)."
		return 1
	fi

	"$interpreter" "$tmpfile"
	rm -f "$tmpfile"
}

if [ ! -d "$DOTFILES_DIR/.git" ]; then
	if [ -e "$DOTFILES_DIR" ]; then
		echo "$DOTFILES_DIR exists but is not a git repo; aborting."
		exit 1
	fi

	if ! command -v git >/dev/null 2>&1; then
		if [ "$OS_NAME" = "Darwin" ]; then
			echo "git not found; install Xcode Command Line Tools and rerun."
			exit 1
		elif [ -f /etc/os-release ] && \
			( grep -q '^ID=debian' /etc/os-release || grep -q '^ID=ubuntu' /etc/os-release ); then
			sudo apt-get update
			sudo apt-get install -y git
		else
			echo "git not found and OS is unsupported for auto-install."
			exit 1
		fi
	fi

	clone_repo="$DOTFILES_REPO_SSH"
	if ! git ls-remote "$DOTFILES_REPO_SSH" >/dev/null 2>&1; then
		echo "SSH access failed; falling back to HTTPS."
		clone_repo="$DOTFILES_REPO_HTTPS"
	fi

	if ! git clone "$clone_repo" "$DOTFILES_DIR"; then
		echo "Failed to clone $clone_repo."
		exit 1
	fi
fi

mkdir -p ~/.config/kitty
mkdir -p ~/.config/nvim
mkdir -p ~/.vim/wiki
mkdir -p ~/.vim/dict
mkdir -p ~/.vim/undo

ln -s "$DOTFILES_DIR/vimrc" ~/.config/nvim/init.vim
ln -s "$DOTFILES_DIR/lua" ~/.config/nvim/lua
ln -s "$DOTFILES_DIR/zshrc" ~/.zshrc
ln -s "$DOTFILES_DIR/vimrc" ~/.vimrc
ln -s "$DOTFILES_DIR/kitty.conf" ~/.config/kitty/kitty.conf
ln -s "$DOTFILES_DIR/Material Darker.conf" ~/.config/kitty/Material\ Darker.conf
ln -s "$DOTFILES_DIR/rasmus.conf" ~/.config/kitty/rasmus.conf
ln -s "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf

VIM_PLUG_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
download_file "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "$VIM_PLUG_PATH"

if command -v zsh >/dev/null 2>&1; then
	run_remote_script "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
else
	echo "zsh not found (skipping oh-my-zsh install)"
fi

if [ "$OS_NAME" = "Darwin" ]; then
	if ! command -v brew >/dev/null 2>&1; then
		run_remote_script "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh" "/bin/bash"
	fi
	brew install stats bash-language-server yaml-language-server ripgrep neovim kitty
elif [ -f /etc/os-release ] && \
	( grep -q '^ID=debian' /etc/os-release || grep -q '^ID=ubuntu' /etc/os-release ); then
	sudo apt-get update
	sudo apt-get install -y ripgrep neovim
elif [ -f /etc/os-release ] && grep -q '^ID=alpine' /etc/os-release; then
	if command -v sudo >/dev/null 2>&1; then
		sudo apk add --no-cache ripgrep neovim
	else
		apk add --no-cache ripgrep neovim
	fi
else
	echo "Unsupported OS for package install (skipping)."
fi

nvim +PlugInstall +qa
