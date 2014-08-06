#!/bin/sh

sudo apt-get install zsh autojump
sudo chsh /bin/zsh

ln -sf ~/dotfiles/zsh/zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/zshenv ~/.zshenv
ln -sf ~/dotfiles/zsh/zlogin ~/.zlogin
ln -sf ~/dotfiles/zsh/oh-my-zsh ~/.oh-my-zsh
ln -sf ~/dotfiles/zsh/custom/* ~/.oh-my-zsh/custom
