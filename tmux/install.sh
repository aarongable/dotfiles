#!/bin/sh

sudo apt-get install tmux fonts-powerline

ln -sfT ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -sfT ~/dotfiles/tmux/tmux-powerlinerc ~/.tmux-powerlinerc
