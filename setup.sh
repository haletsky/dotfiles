#! /bin/bash

mkdir -p ~/.config/kitty
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

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
