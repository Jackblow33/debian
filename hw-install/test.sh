#!/bin/bash

#wifiinstall   Broadcom - imac BCM4360 & +++

# Source: https://wiki.debian.org/wl

#VARIABLE
#SUITES=trixie  #Choose between trixie or sid


# Backup the original sources.list file
cp /etc/apt/sources.list /etc/apt/$TIMESTAMP.sources.list

#NEW -edit sources.list
#echo "contrib non-free" | sudo tee -a /etc/apt/sources.list
# OR
#sudo sh -c 'echo "[some repository]" >> /etc/apt/sources.list'

#NEW -add sources.list into /etc/apt/sources.list.d
# Create the sources.list file in the /etc/apt/sources.list.d
sudo touch /etc/apt/sources.list.d/sources.list

# Add the following text to the file
echo "# Modernized from /etc/apt/sources.list" | sudo tee /etc/apt/sources.list.d/sources.list
echo "Types: deb deb-src" | sudo tee /etc/apt/sources.list.d/sources.list
echo "URIs: http://deb.debian.org/debian/" | sudo tee /etc/apt/sources.list.d/sources.list
echo "Suites: trixie" | sudo tee /etc/apt/sources.list.d/sources.list
echo "Components: main non-free-firmware contrib non-free" | sudo tee /etc/apt/sources.list.d/sources.list
echo "Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg" | sudo tee /etc/apt/sources.list.d/sources.list



# Update the package lists
apt-get update
echo "The non-free contrib repository has been added to the sources.list file."

