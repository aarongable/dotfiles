#!/bin/bash
# Intended for use with Ubuntu 12.04 LTS.

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt update
sudo apt install sway swaybg swayidle swaylock
sudo apt install fuzzel
sudo apt install waybar fonts-font-awesome sway-notification-center
sudo apt install brightnessctl pavucontrol
sudo apt install wl-clipboard grim slurp jq
sudo apt install kitty

mkdir -p $XDG_CONFIG_HOME/sway
ln -sfT $THIS_DIR/sway.config $XDG_CONFIG_HOME/sway/config

mkdir -p $XDG_CONFIG_HOME/waybar
ln -sfT $THIS_DIR/waybar.json $XDG_CONFIG_HOME/waybar/config
ln -sfT $THIS_DIR/waybar.css $XDG_CONFIG_HOME/waybar/style.css

mkdir -p $XDG_CONFIG_HOME/swaylock
ln -sfT $THIS_DIR/swaylock.config $XDG_CONFIG_HOME/swaylock/config

mkdir -p $XDG_CONFIG_HOME/swaync
ln -sfT $THIS_DIR/swaync.json $XDG_CONFIG_HOME/swaync/config.json
ln -sfT $THIS_DIR/swaync.css $XDG_CONFIG_HOME/swaync/style.json

mkdir -p $XDG_CONFIG_HOME/fuzzel
ln -sfT $THIS_DIR/fuzzel.ini $XDG_CONFIG_HOME/fuzzel/fuzzel.ini

mkdir -p $XDG_DATA_HOME/sway
ln -sfT $THIS_DIR/wallpaper.jpg $XDG_DATA_HOME/sway/wallpaper.jpg
ln -sfT $THIS_DIR/lockscreen.jpg $XDG_DATA_HOME/sway/lockscreen.jpg
ln -sfT $THIS_DIR/grimshot.sh ~/.local/bin/grimshot

# Log out -> select Sway -> log in.
