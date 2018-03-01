#!/bin/sh

# Use neovim because it's the future now.
sudo apt-get install nvim
sudo update-alternatives --set editor /usr/bin/nvim
sudo update-alternatives --set vim /usr/bin/nvim

# nvim config lives in $XDG_CONFIG_HOME/nvim/.
mkdir -p ~/.config/nvim
ln -sfT ~/dotfiles/vim/init.vim ~/.config/nvim/init.vim

# nvim plugins live in $XDG_DATA_HOME/nvim/site/.
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.local/share/nvim/site/plugged

# nvim throwaway data lives in $XDG_CACHE_HOME/nvim/.
mkdir -p ~/.cache/nvim/backup
mkdir -p ~/.cache/nvim/swap
mkdir -p ~/.cache/nvim/undo

# Install YouCompleteMe dependencies.
sudo apt-get install cmake pip
pip install --user neovim

nvim +PlugInstall
