#!/bin/sh
# tmux-multi
# nodir@
# Based on https://gist.github.com/dmytro/3984680

# This script opens a new tmux window and for each command line arg creates
# a pane with ARG variable set to a value of the arg. Keyboard input on all
# panes is synchronized.

# An example of usage:
# $ tmux-multi.sh host{1..10}.tld
# $ ssh $ARG
# $ shutdown -r -t now

starttmux() {
    first=true
    local args=( $ARGS )
    for ARG in "${args[@]}"; do
        local cmd="export ARG=$ARG && echo ARG=$ARG && $SHELL"
        if [ "$first" == "true" ]; then
          tmux new-window "$cmd"
          first=false
        else
          tmux split-window -h "$cmd"
          tmux select-layout tiled > /dev/null
        fi
    done
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null
}

ARGS=$*

starttmux