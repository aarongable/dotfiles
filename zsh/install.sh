#!/bin/sh

sudo apt-get install zsh autojump
sudo chsh -s /usr/bin/zsh
mkdir -p ~/dotfiles/zsh/oh-my-zsh/custom/themes

ln -sf ~/dotfiles/zsh/zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/zshenv ~/.zshenv
ln -sf ~/dotfiles/zsh/zlogin ~/.zlogin
ln -sf ~/dotfiles/zsh/oh-my-zsh ~/.oh-my-zsh
ln -sf ~/dotfiles/zsh/custom/*.zsh ~/.oh-my-zsh/custom
ln -sf ~/dotfiles/zsh/custom/themes/*.zsh-theme ~/.oh-my-zsh/custom/themes/
ln -sf ~/dotfiles/zsh/custom/plugins/* ~/.oh-my-zsh/custom/plugins/
