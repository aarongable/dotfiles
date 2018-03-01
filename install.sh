#!/bin/sh

# This script sets up the entire dotfiles environment. It is only expected
# to be run after the dotfiles repo has been cloned into your location of
# choice.
# Note: This script (and entire repo) is only expected to work on Ubuntu.

# We like the XDG_CONFIG standard, so make sure it is set up.
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=${HOME}/.cache}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:=${HOME}/.local/share}

# Find the location of this file and the dotfile repo directory.
DOTFILES=`dirname "$(readlink -f "$0")"`

# Ensure all of the submodules are properly set up
git -C $DOTFILES submodule update --init

# Simply invoke the install script from each section of this repo.
dirs=$(find $DOTFILES -maxdepth 1 -mindepth 1 -type d -not -name '.git' -print)
for dir in $dirs
do
  echo "Installing ${dir}..."
  $dir/install.sh
done
