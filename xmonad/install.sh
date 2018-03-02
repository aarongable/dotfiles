#!/bin/bash
# Intended for use with Ubuntu 12.04 LTS.

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt-get install xmonad xmobar suckless-tools i3lock

mkdir -p $XDG_CONFIG_HOME/xmonad
ln -sfT $THIS_DIR/xmonad.hs $XDG_CONFIG_HOME/xmonad/xmonad.hs
mkdir -p $XDG_CONFIG_HOME/xmobar
ln -sfT $THIS_DIR/xmobarrc $XDG_CONFIG_HOME/xmobar/xmobarrc

xmonad --recompile

# Log out -> select Xmonad -> log in.
