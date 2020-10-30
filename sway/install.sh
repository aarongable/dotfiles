#!/bin/bash
# Intended for use with Ubuntu 12.04 LTS.

THIS_DIR=`dirname "$(readlink -f "$0")"`

# sudo apt-add-repository ppa:nschloe/waybar
# sudo apt-add-repository ppa:mmstick76/alacritty
# sudo apt update
sudo apt install sway dmenu swaybg swayidle swaylock
sudo apt install waybar fonts-font-awesome mako-notifier
sudo apt install brightnessctl pavucontrol
sudo apt install wl-clipboard grim slurp jq
sudo apt install alacritty

mkdir -p $XDG_CONFIG_HOME/sway
ln -sfT $THIS_DIR/sway.config $XDG_CONFIG_HOME/sway/config

mkdir -p $XDG_CONFIG_HOME/waybar
ln -sfT $THIS_DIR/waybar.json $XDG_CONFIG_HOME/waybar/config
ln -sfT $THIS_DIR/waybar.css $XDG_CONFIG_HOME/waybar/style.css

mkdir -p $XDG_CONFIG_HOME/swaylock
ln -sfT $THIS_DIR/swaylock.config $XDG_CONFIG_HOME/swaylock/config

mkdir -p $XDG_CONFIG_HOME/mako
ln -sfT $THIS_DIR/mako.config $XDG_CONFIG_HOME/mako/config

mkdir -p $XDG_DATA_HOME/sway
ln -sfT $THIS_DIR/wallpaper.jpg $XDG_DATA_HOME/sway/wallpaper.jpg
ln -sfT $THIS_DIR/lockscreen.jpg $XDG_DATA_HOME/sway/lockscreen.jpg
ln -sfT $THIS_DIR/grimshot.sh ~/.local/bin/grimshot

# Log out -> select Sway -> log in.
