#!/bin/bash

#wifiinstall   Broadcom - imac BCM4360 & +++

#Source: https://wiki.debian.org/wl

#Before executing!!! Add a "non-free" component to /etc/apt/sources.list for your Debian version, for example: 
#Debian 12 "Bookworm"
#deb http://deb.debian.org/debian bookworm main contrib non-free-firmware non-free
#OR
#deb http://deb.debian.org/debian/ trixie main non-free-firmware contrib non-free

#Update the list of available packages. Install the relevant/latest linux-image, linux-headers and broadcom-sta-dkms packages
sudo apt-get update
sudo apt-get install linux-image-$(uname -r|sed 's,[^-]*-[^-]*-,,') linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms

#(Optional) Check all the built DKMS kernel modules. There should be "wl.ko" in the list. 
# find /lib/modules/$(uname -r)/updates

#Unload conflicting modules:
modprobe -r b44 b43 b43legacy ssb brcmsmac bcma

#Unloading and reloading modules
sudo modprobe -r wl && sudo modprobe wl





#OLD
#cd /home/$USER/Downloads
#sudo wget http://http.us.debian.org/debian/pool/non-free/b/broadcom-sta/broadcom-sta-dkms_6.30.223.271-26_amd64.deb
#sudo apt install linux-image-amd64 linux-headers-amd64 wireless-tools #broadcom-sta-dkms
