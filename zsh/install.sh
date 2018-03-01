#!/bin/sh

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt-get install zsh autojump
sudo chsh -s /usr/bin/zsh

# Install the google-cloud-sdk. Make sure to install in in $HOME/.local/share/
curl https://sdk.cloud.google.com | bash

ln -sfT $THIS_DIR/bootstrap ~/.zshenv

ln -sfT $THIS_DIR/zshenv $XDG_CONFIG_HOME/zsh/.zshenv
ln -sfT $THIS_DIR/zshrc $XDG_CONFIG_HOME/zsh/.zshrc
ln -sfT $THIS_DIR/zlogin $XDG_CONFIG_HOME/zsh/.zlogin

ln -sfT $THIS_DIR/custom $XDG_DATA_HOME/zsh/custom
ln -sfT $THIS_DIR/oh-my-zsh $XDG_DATA_HOME/zsh/oh-my-zsh
