#!/bin/sh

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt install opensc libpcsclite-dev pcscd

# Get and install the latest version of yubikey-agent
go get filippo.io/yubikey-agent
go install filippo.io/yubikey-agent

# Install the agent binary and its service configuration
mkdir -p $XDG_CONFIG_HOME/systemd/user
sudo cp $HOME/go/bin/yubikey-agent /usr/local/bin/
sudo ln -s $THIS_DIR/yubikey-agent-launch /usr/local/bin/
ln -s $THIS_DIR/yubikey-agent.service $XDG_CONFIG_HOME/systemd/user/
systemctl --user enable yubikey-agent
sudo sed -i 's/use-ssh-agent/use-yubikey-agent/' /etc/X11/Xsession.options
systemctl --user start yubikey-agent
