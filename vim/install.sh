#!/bin/sh

THIS_DIR=`dirname "$(readlink -f "$0")"`

# Use neovim because it's the future now.
sudo apt-get install neovim
sudo update-alternatives --set editor /usr/bin/nvim
sudo update-alternatives --set vim /usr/bin/nvim

mkdir -p $XDG_CONFIG_HOME/nvim
ln -sfT $THIS_DIR/init.vim $XDG_CONFIG_HOME/nvim/init.vim

curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p $XDG_DATA_HOME/nvim/site/plugged

mkdir -p $XDG_CACHE_HOME/nvim/backup
mkdir -p $XDG_CACHE_HOME/nvim/swap
mkdir -p $XDG_CACHE_HOME/nvim/undo

# Install YouCompleteMe dependencies.
sudo apt-get install cmake python-pip
pip install --user neovim

nvim +PlugInstall
