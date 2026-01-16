#! /bin/bash

DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_REPO="git@github.com:haletsky/dotfiles.git"
OS_NAME="$(uname -s)"

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

	git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
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

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if command -v zsh >/dev/null 2>&1; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "zsh not found (skipping oh-my-zsh install)"
fi

if [ "$OS_NAME" = "Darwin" ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew install stats bash-language-server yaml-language-server ripgrep neovim kitty
elif [ -f /etc/os-release ] && \
	( grep -q '^ID=debian' /etc/os-release || grep -q '^ID=ubuntu' /etc/os-release ); then
	sudo apt-get update
	sudo apt-get install -y ripgrep neovim kitty bash-language-server node-yaml-language-server
else
	echo "Unsupported OS for package install (skipping)."
fi
