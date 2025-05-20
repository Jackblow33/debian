#!/bin/bash

# Check if the blacklist file exists
if [ -f "/etc/modprobe.d/blacklist-nouveau.conf" ]; then
    # Check if the blacklist entries already exist
    if ! grep -q "blacklist nouveau" "/etc/modprobe.d/blacklist-nouveau.conf"; then
        echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf
    fi
    if ! grep -q "options nouveau modeset=0" "/etc/modprobe.d/blacklist-nouveau.conf"; then
        echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
    fi
else
    # Create the blacklist file and add the entries
    echo "blacklist nouveau" > /etc/modprobe.d/blacklist-nouveau.conf
    echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
fi

# Update initramfs
update-initramfs -u

# echo "Nouveau driver has been blacklisted. Please reboot your system for the changes to take effect."
