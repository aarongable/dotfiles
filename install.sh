#!/bin/sh

cd

# If the repo hasn't been cloned already (i.e. you trust me and are running
# this script blindly after curling it according to the instructions in the
# README... you silly person, you) then do so now.

if [ ! -d dotfiles ]
then
  sudo apt-get install git
  git clone --recursive https://github.com/aarongable/dotfiles.git
fi

# Simply invokes the install script for each section of this repo.

dirs=$(find dotfiles -maxdepth 1 -mindepth 1 -type d -not -name '.git' -print)
for dir in $dirs
do
  echo "Installing ${dir}..."
  $dir/install.sh
done
