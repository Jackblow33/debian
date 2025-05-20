#!/bin/bash

# Check if the blacklist file exists
if [ -f "/etc/modprobe.d/blacklist-nvidia.conf" ]; then
    # Check if the blacklist entries already exist
    if ! grep -q "blacklist nvidia" "/etc/modprobe.d/blacklist-nvidia.conf"; then
        echo "blacklist nvidia" >> /etc/modprobe.d/blacklist-nvidia.conf
    fi
    if ! grep -q "blacklist nvidia_drm" "/etc/modprobe.d/blacklist-nvidia.conf"; then
        echo "blacklist nvidia_drm" >> /etc/modprobe.d/blacklist-nvidia.conf
    fi
    if ! grep -q "blacklist nvidia_modeset" "/etc/modprobe.d/blacklist-nvidia.conf"; then
        echo "blacklist nvidia_modeset" >> /etc/modprobe.d/blacklist-nvidia.conf
    fi
    if ! grep -q "blacklist nvidia_uvm" "/etc/modprobe.d/blacklist-nvidia.conf"; then
        echo "blacklist nvidia_uvm" >> /etc/modprobe.d/blacklist-nvidia.conf
    fi
else
    # Create the blacklist file and add the entries
    echo "blacklist nvidia" > /etc/modprobe.d/blacklist-nvidia.conf
    echo "blacklist nvidia_drm" >> /etc/modprobe.d/blacklist-nvidia.conf
    echo "blacklist nvidia_modeset" >> /etc/modprobe.d/blacklist-nvidia.conf
    echo "blacklist nvidia_uvm" >> /etc/modprobe.d/blacklist-nvidia.conf
fi

# Update initramfs
update-initramfs -u

# echo "NVIDIA driver has been blacklisted. Please reboot your system for the changes to take effect."
