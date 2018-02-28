#!/bin/sh

ln -sfT ~/dotfiles/git/gitconfig ~/.config/git/config

echo "What email address do you want to use for git?"
read email
cat << EOF >> ~/.config/git/customconfig
[user]
  email = $email
EOF
