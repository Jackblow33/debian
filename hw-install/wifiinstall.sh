#!/bin/bash

#Execute as root
#wifiinstall   Broadcom - imac BCM4360 & +++

# Source: https://wiki.debian.org/wl

USR=jack

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Backup the original sources.list file
cp /etc/apt/sources.list /etc/apt/$TIMESTAMP.sources.list

# Add the non-free contrib repository to the sources.list file
#echo "deb http://deb.debian.org/debian/ trixie non-free contrib" >> /etc/apt/sources.list

cp /home/$USR/debian/files/sources.list /etc/apt/sources.list.d

# Update the package lists
apt-get update

echo "The non-free contrib repository has been added to the sources.list file."

# Install
sudo apt-get install linux-image-$(uname -r|sed 's,[^-]*-[^-]*-,,') linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms

# (Optional) Check all the built DKMS kernel modules. There should be "wl.ko" in the list. 
# find /lib/modules/$(uname -r)/updates

# Unload conflicting modules:
modprobe -r b44 b43 b43legacy ssb brcmsmac bcma

# Unloading and reloading modules
modprobe -r wl && modprobe wl





#OLD
#cd /home/$USER/Downloads
#sudo wget http://http.us.debian.org/debian/pool/non-free/b/broadcom-sta/broadcom-sta-dkms_6.30.223.271-26_amd64.deb
#sudo apt install linux-image-amd64 linux-headers-amd64 wireless-tools #broadcom-sta-dkms
