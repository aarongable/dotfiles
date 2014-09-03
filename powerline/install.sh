#!/bin/sh

sudo apt-get install fontconfig

mkdir ~/.fonts
ln -sfT ~/dotfiles/powerline/powerline-fonts/* ~/.fonts
fc-cache -vf ~/.fonts

mkdir -p ~/.config/fontconfig/conf.d
ln -sfT ~/dotfiles/powerline/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
