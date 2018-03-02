#!/bin/sh

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt-get install git

mkdir -p $XDG_CONFIG_HOME/git/
ln -sfT $THIS_DIR/gitconfig $XDG_CONFIG_HOME/git/config

echo "What email address do you want to use for git?"
read email
cat << EOF >> $XDG_CONFIG_HOME/git/customconfig
[user]
  email = $email
EOF
