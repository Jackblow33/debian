#!/bin/bash

# Source https://wiki.debian.org/NvidiaGraphicsDrivers

sudo apt update
sudo apt install nvidia-detect
nvidia-detect
echo '' ; echo '' ; echo ''
read -p "Press Enter to start installing Nvidia driver ............................>>>"
sudo apt install nvidia-driver  #for sid add: firmware-misc-nonfree

