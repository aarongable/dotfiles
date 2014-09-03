#!/bin/sh

sudo apt-get install tmux

ln -sfT ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -sfT ~/dotfiles/tmux/tmux-powerlinerc ~/.tmux-powerlinerc
