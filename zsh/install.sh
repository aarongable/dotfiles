#!/bin/sh

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt install curl zsh autojump fzf
chsh -s /usr/bin/zsh

# Install antibody to manage zsh plugins.
curl -sfL git.io/antibody | sh -s - -b ~/.local/bin

# Install starship to control the prompt.
curl -fsSL https://starship.rs/install.sh | bash

# Install the google-cloud-sdk. Make sure to install in in $HOME/.local/share/
curl https://sdk.cloud.google.com | bash

ln -sfT $THIS_DIR/bootstrap ~/.zshenv

mkdir -p $XDG_CONFIG_HOME/zsh
ln -sfT $THIS_DIR/zshenv $XDG_CONFIG_HOME/zsh/.zshenv
ln -sfT $THIS_DIR/zshrc $XDG_CONFIG_HOME/zsh/.zshrc
ln -sfT $THIS_DIR/aliases.zsh $XDG_CONFIG_HOME/zsh/aliases.zsh

antibody bundle < $THIS_DIR/plugins.txt > $XDG_CACHE_HOME/zsh/plugins.zsh

# This is where history will be stored.
mkdir -p $XDG_CACHE_HOME/zsh

ln -sfT $THIS_DIR/starship.toml $XDG_CONFIG_HOME/starship.toml
