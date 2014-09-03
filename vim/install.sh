#!/bin/sh

sudo apt-get install vim
# for easytags
sudo apt-get install exuberant-ctags
# for YouCompleteMe
sudo apt-get install build-essential cmake python-dev

# Set up vimified's vimrc
ln -sfT ~/dotfiles/vim/vimified/vimrc ~/.vimrc
ln -sfT ~/dotfiles/vim/before.vimrc ~/dotfiles/vim/vimified/before.vimrc
ln -sfT ~/dotfiles/vim/local.vimrc ~/dotfiles/vim/vimified/local.vimrc
ln -sfT ~/dotfiles/vim/extra.vimrc ~/dotfiles/vim/vimified/extra.vimrc
ln -sfT ~/dotfiles/vim/after.vimrc ~/dotfiles/vim/vimified/after.vimrc
ln -sfT ~/dotfiles/vim/after ~/dotfiles/vim/vimified/after

# Set up basic things
mkdir -p ~/dotfiles/vim/vimified/tmp/backup
mkdir -p ~/dotfiles/vim/vimified/tmp/swap
mkdir -p ~/dotfiles/vim/vimified/tmp/undo

# Set up vundle
mkdir -p ~/dotfiles/vim/vimified/bundle
ln -sfT ~/dotfiles/vim/vundle ~/dotfiles/vim/vimified/bundle/vundle

# Install YCM
SAVED_DIR=$PWD
cd ~/dotfiles/vim/vimified/bundle/YouCompleteMe
./install.sh
cd $SAVED_DIR

# Finally link vimified into place.
ln -sfT ~/dotfiles/vim/vimified ~/.vim

vim +BundleInstall +qall
