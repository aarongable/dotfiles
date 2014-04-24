#!/bin/bash
# Intended for use with Ubuntu 12.04 LTS.

sudo apt-get install xmonad gnome-panel suckless-tools
rm ~/.xmonad/xmonad-x86_64-linux
xmonad --recompile
#logout
#Ubuntu -> Gnome with Xmonad -> login

# Tips:
# Win+Enter = new terminal
# Win+Shift+Enter = launcher (start typing name of program, press enter)
# Win+j/k = navigate windows on one monitor
# Win+h/l = switch between monitors
# Win+Num = switch monitor to that workspace
# All other keyboard shortcuts documented in xmonad.hs
