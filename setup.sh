#! /bin/bash

mkdir -p ~/.config/kitty
mkdir -p ~/.config/nvim
mkdir -p ~/.vim/wiki
mkdir -p ~/.vim/dict
mkdir -p ~/.vim/undo

ln -s ~/dotfiles/vimrc ~/.config/nvim/init.vim
ln -s ~/dotfiles/lua ~/.config/nvim/lua
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/kitty.conf ~/.config/kitty/kitty.conf
ln -s ~/dotfiles/Material\ Darker.conf ~/.config/kitty/Material\ Darker.conf
ln -s ~/dotfiles/rasmus.conf ~/.config/kitty/rasmus.conf
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if command -v zsh >/dev/null 2>&1; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "zsh not found (skipping oh-my-zsh install)"
fi

OS_NAME="$(uname -s)"
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
