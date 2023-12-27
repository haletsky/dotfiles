#! /usr/bin/bash

mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/kitty
mkdir -p ~/.vim/wiki
mkdir -p ~/.vim/dict
mkdir -p ~/.vim/undo

ln -s ./vimrc ~/.config/nvim/init.vim
ln -s ./lua ~/.config/nvim/lua
ln -s ./zshrc ~/.zshrc
ln -s ./vimrc ~/.vimrc
ln -s ./kitty.conf ~/.config/kitty/kitty.conf
ln -s ./Material\ Darker.conf ~/.config/kitty/Material\ Darker.conf

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
