#!/bin/sh

sudo apt-get install vim
# for easytags
sudo apt-get install exuberant-ctags
# for YouCompleteMe
sudo apt-get install build-essential cmake python-dev

ln -sf ~/dotfiles/vim/vimified ~/.vim
ln -sf ~/dotfiles/vim/vimified/vimrc ~/.vimrc

ln -sf ~/dotfiles/vim/before.vimrc ~/.vim/before.vimrc
ln -sf ~/dotfiles/vim/local.vimrc ~/.vim/local.vimrc
ln -sf ~/dotfiles/vim/extra.vimrc ~/.vim/extra.vimrc
ln -sf ~/dotfiles/vim/after.vimrc ~/.vim/after.vimrc

mkdir -p ~/.vim/bundle ~/.vim/tmp/backup ~/.vim/tmp/swap ~/.vim/tmp/undo

ln -sf ~/dotfiles/vim/vundle ~/.vim/bundle/vundle

vim +BundleInstall +qall

SAVED_DIR=$PWD
cd ~/.vim/bundle/YouCompleteMe
./install.sh
cd $SAVED_DIR
