#!/bin/bash

# Source https://wiki.debian.org/NvidiaGraphicsDrivers
# Must have proper repos enabled

sudo apt update
sudo apt install nvidia-detect
nvidia-detect
echo '' ; echo '' ; echo ''
read -p "Press Enter to start installing Nvidia driver ............................>>>"
sudo apt install nvidia-driver  #for sid add: firmware-misc-nonfree
#sudo systemctl --user enable --now nvidia-x11-xserver-settings.service

