#!/bin/sh

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt install curl zsh autojump hsetroot
chsh -s /usr/bin/zsh

# Install the google-cloud-sdk. Make sure to install in in $HOME/.local/share/
curl https://sdk.cloud.google.com | bash

ln -sfT $THIS_DIR/bootstrap ~/.zshenv

mkdir -p $XDG_CONFIG_HOME/zsh
ln -sfT $THIS_DIR/zshenv $XDG_CONFIG_HOME/zsh/.zshenv
ln -sfT $THIS_DIR/zshrc $XDG_CONFIG_HOME/zsh/.zshrc
ln -sfT $THIS_DIR/zlogin $XDG_CONFIG_HOME/zsh/.zlogin

mkdir -p $XDG_DATA_HOME/zsh
ln -sfT $THIS_DIR/custom $XDG_DATA_HOME/zsh/custom
ln -sfT $THIS_DIR/oh-my-zsh $XDG_DATA_HOME/zsh/oh-my-zsh

# This is where history will be stored.
mkdir -p $XDG_CACHE_HOME/zsh
