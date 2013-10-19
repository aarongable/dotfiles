#!/bin/sh

sudo apt-get install zsh
sudo chsh /bin/zsh

ln -sf ~/dotfiles/zsh/zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/oh-my-zsh ~/.oh-my-zsh
ln -sf ~/dotfiles/zsh/custom/* ~/.oh-my-zsh/custom
