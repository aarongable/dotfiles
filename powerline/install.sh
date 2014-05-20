#!/bin/sh

sudo apt-get install fontconfig

mkdir ~/.fonts
ln -sf ~/dotfiles/powerline/PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts

mkdir -p ~/.config/fontconfig/conf.d
ln -sf ~/dotfiles/powerline/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
