#!/bin/sh
# multi-delay
# agable@

# This script takes a shell command as input, waits a random amount of time,
# and then executes the command. The amount of time must be constrained between
# lower and upper bounds (in seconds) with the first two parameters.

# An example of usage:
# $ tmux-multi.sh host{1..10}.tld
# $ multi-delay.sh 0 1 ssh $ARG

function usage {
  echo "Usage: ./multi-delay.sh M N cmd [args]"
  echo "Must provide a min delay, max delay, and command with optional args."
  exit 1
}

if [ ! $# -ge 3 ]; then
  echo "Invalid number of arguments."
  usage
fi

a=$(($RANDOM % $(($2 - $1 + 1)) + $1))
echo $a
sleep $a
shift
shift
$@
