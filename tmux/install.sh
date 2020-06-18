#!/bin/sh

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt install tmux fonts-powerline

ln -sfT $THIS_DIR/tmux.conf ~/.tmux.conf
ln -sfT $THIS_DIR/tmux-powerlinerc ~/.tmux-powerlinerc
