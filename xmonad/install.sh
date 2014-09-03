#!/bin/bash
# Intended for use with Ubuntu 12.04 LTS.

sudo apt-get install xmonad xmobar gnome-panel suckless-tools

mkdir -p ~/.xmonad
ln -sfT ~/dotfiles/xmonad/xmonad.hs ~/.xmonad/xmonad.hs
ln -sfT ~/dotfiles/xmonad/xmobarrc ~/.xmobarrc

rm -f ~/.xmonad/xmonad-x86_64-linux
xmonad --recompile

# Log out -> select Xmonad -> log in.

ln -sfT ~/dotfiles/xmonad/xession ~/.xsession
