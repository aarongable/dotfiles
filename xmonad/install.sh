#!/bin/bash
# Intended for use with Ubuntu 12.04 LTS.

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt install xmonad xmobar suckless-tools i3lock feh maim xclip

# Also used for compile artifacts.
mkdir -p $XDG_DATA_HOME/xmonad
ln -sfT $THIS_DIR/firewatch.jpg $XDG_DATA_HOME/xmonad/wallpaper.jpg

mkdir -p $XDG_CONFIG_HOME/xmonad
ln -sfT $THIS_DIR/xmonad.hs $XDG_CONFIG_HOME/xmonad/xmonad.hs
mkdir -p $XDG_CONFIG_HOME/xmobar
ln -sfT $THIS_DIR/xmobarrc $XDG_CONFIG_HOME/xmobar/xmobarrc

mkdir -p $HOME/.local/bin
ln -sfT $THIS_DIR/screenshot.sh $HOME/.local/bin/screenshot.sh

xmonad --recompile

# Log out -> select Xmonad -> log in.
