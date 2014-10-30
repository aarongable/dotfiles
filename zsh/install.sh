#!/bin/sh

sudo apt-get install zsh autojump
sudo chsh -s /usr/bin/zsh
mkdir -p ~/dotfiles/zsh/oh-my-zsh/custom/themes

ln -sfT ~/dotfiles/zsh/zshrc ~/.zshrc
ln -sfT ~/dotfiles/zsh/zshenv ~/.zshenv
ln -sfT ~/dotfiles/zsh/zlogin ~/.zlogin
ln -sfT ~/dotfiles/zsh/oh-my-zsh ~/.oh-my-zsh
for z in `ls ~/dotfiles/zsh/custom/*.zsh`; do
  ln -sfT ~/dotfiles/zsh/custom/$z ~/.oh-my-zsh/custom/$(basename $z)
done
for t in `ls ~/dotfiles/zsh/custom/themes`; do
  ln -sfT ~/dotfiles/zsh/custom/themes/$t ~/.oh-my-zsh/custom/themes/$t
done
for p in `ls ~/dotfiles/zsh/custom/plugins`; do
  ln -sfT ~/dotfiles/zsh/custom/plugins/$p ~/.oh-my-zsh/custom/plugins/$p
done

