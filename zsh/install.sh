#!/bin/sh

sudo apt-get install zsh autojump
sudo chsh -s /usr/bin/zsh
mkdir -p ~/dotfiles/zsh/oh-my-zsh/custom/themes

ln -sfT ~/dotfiles/zsh/zshrc ~/.zshrc
ln -sfT ~/dotfiles/zsh/zshenv ~/.zshenv
ln -sfT ~/dotfiles/zsh/zlogin ~/.zlogin
ln -sfT ~/dotfiles/zsh/oh-my-zsh ~/.oh-my-zsh
ln -sfT ~/dotfiles/zsh/custom/*.zsh ~/.oh-my-zsh/custom
ln -sfT ~/dotfiles/zsh/custom/themes/*.zsh-theme ~/.oh-my-zsh/custom/themes/
ln -sfT ~/dotfiles/zsh/custom/plugins/* ~/.oh-my-zsh/custom/plugins/
