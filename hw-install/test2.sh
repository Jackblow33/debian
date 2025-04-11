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
cp /etc/apt/sources.list.d/sources.list /etc/apt/sources.list.d/$TIMESTAMP.sources.list

# Add the non-free contrib repository to the sources.list file
#echo "deb http://deb.debian.org/debian/ trixie non-free contrib" >> /etc/apt/sources.list

cp /home/$USR/debian/files/sources.list /etc/apt/sources.list.d

# Update the package lists
apt-get update

echo "The non-free contrib repository has been added to the sources.list file."

