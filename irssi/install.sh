#!/bin/sh

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt install irssi

ln -sfT $THIS_DIR ~/.irssi
