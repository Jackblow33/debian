#!/bin/bash

sudo apt install nvidia-detect
nvidia-detect
echo '' ; echo '' ; echo ''
read -p "Press Enter to start installing Nvidia driver ............................>>>"
sudo apt install nvidia-driver
