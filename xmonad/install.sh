#!/bin/bash
# Intended for use with Ubuntu 12.04 LTS.

sudo apt-get install xmonad xmobar gnome-panel suckless-tools

mkdir -p ~/.xmonad
ln -sf ~/dotfiles/xmonad/xmonad.hs ~/.xmonad/xmonad.hs
ln -sf ~/dotfiles/xmonad/xmobarrc ~/.xmobarrc

rm -f ~/.xmonad/xmonad-x86_64-linux
xmonad --recompile
#logout
#Ubuntu -> Gnome with Xmonad -> login

ln -sf ~/dotfiles/xmonad/xession ~/.xsession

# Tips:
# Win+Enter = new terminal
# Win+Shift+Enter = launcher (start typing name of program, press enter)
# Win+j/k = navigate windows on one monitor
# Win+h/l = switch between monitors
# Win+Num = switch monitor to that workspace
# All other keyboard shortcuts documented in xmonad.hs
