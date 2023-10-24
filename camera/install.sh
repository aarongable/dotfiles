#!/bin/sh

THIS_DIR=`dirname "$(readlink -f "$0")"`

sudo apt install v4l2loopback-dkms v4l2loopback-utils gphoto2 ffmpeg

# Create the systemd service that streams video from the camera
sudo ln -sfT $THIS_DIR/dslr-webcam.service /lib/systemd/system/dslr-webcam.service
sudo systemctl disable dslr-webcam

# Create the udev rule that starts the systemd service when the camera connects
sudo ln -sfT $THIS_DIR/dslr-webcam.rules /lib/udev/rules.d/35-dslr-webcam.rules
