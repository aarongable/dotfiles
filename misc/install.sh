#!/bin/sh

mkdir -p ~/.config/gtk-3.0
ln -s fix-f10-in-gnome.txt ~/.config/gtk-3.0/gtk.css

# Install the google-cloud-sdk. Make sure to install in in $HOME/bin/
curl https://sdk.cloud.google.com | bash
