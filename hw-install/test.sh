#!/bin/bash

#Execute as root
#wifiinstall   Broadcom - imac BCM4360 & +++

# Source: https://wiki.debian.org/wl

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Backup the original sources.list file
cp /etc/apt/sources.list /etc/apt/$TIMESTAMP.sources.list

#NEW -edit sources.list
#echo "contrib non-free" | sudo tee -a /etc/apt/sources.list
# OR
#sudo sh -c 'echo "[some repository]" >> /etc/apt/sources.list'

#NEW -add sources.list into /etc/apt/sources.list.d
touch /etc/apt/sources.list.d/sources.list
echo "# Modernized from /etc/apt/sources.list"                    >> /etc/apt/sources.list.d/sources.list
echo "Types: deb deb-src"                                         >> /etc/apt/sources.list.d/sources.list
echo "URIs: http://deb.debian.org/debian/"                        >> /etc/apt/sources.list.d/sources.list
echo "Suites: trixie"                                             >> /etc/apt/sources.list.d/sources.list
echo "Components: contrib non-free"                               >> /etc/apt/sources.list.d/sources.list
echo "Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg"  >> /etc/apt/sources.list.d/sources.list


# Update the package lists
apt-get update
echo "The non-free contrib repository has been added to the sources.list file."

