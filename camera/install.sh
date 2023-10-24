#!/bin/sh

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt install v4l2loopback-dkms v4l2loopback-utils gphoto2 ffmpeg

# Create the systemd service that streams video from the camera
sudo ln -s $THIS_DIR/dslr-webcam.service /etc/systemd/system/

# Create the udev rule that starts the systemd service when the camera connects
sudo ln -s $THIS_DIR/dslr-webcam.rules /lib/udev/rules.d/35-dslr-webcam.rules
