#!/bin/sh
# multi-delay
# agable@

# This script takes a shell command as input, waits a random amount of time,
# and then executes the command. The amount of time must be constrained between
# lower and upper bounds (in seconds) with the first two parameters.

# An example of usage:
# $ tmux-multi.sh host{1..10}.tld
# $ multi-delay.sh 0 1 ssh $ARG

runcommand(min, max, cmd) {


}
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
