#!/usr/bin/env bash
set -uex

modprobe -r v4l2loopback
modprobe v4l2loopback exclusive_caps=1 max_buffers=2 card_label="Virtual Camera"
gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0
