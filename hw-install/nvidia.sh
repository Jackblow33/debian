#!/bin/bash

#2025-04-15

# nvidia.sh - Script to install NVIDIA drivers on Debian 12 - Trixie & Sid. Untested on Stable but might work.

# Execute as root
# Linux kernel 6.11 and beyond required


# Function to handle errors
handle_error() {
    echo "Error occurred in the script. Exiting."
    exit 1
}

clear
echo -e "\n\n\n\n\n\n\n\n\n\n"
echo -e '\033[1;31mTo fix some power management issue and enable drm modeset the file nvidia-options.conf would be created into /etc/default/grub.d\033[0m'
echo -e "\n\n\n"
read -p "Press Enter to continue or 'x' to exit: " input
if [ "$input" = "x" ]; then
    exit
else
    echo "Continuing..."
fi


# Start timer
timer_start

# Update package list and install necessary packages
# apt update && apt install -y linux-headers-$(uname -r) build-essential dkms libglvnd-dev pkg-config || handle_error
apt update && apt install -y linux-headers-$(uname -r) gcc make acpid dkms libvulkan1 pkg-config libglvnd-dev || handle_error   #libglvnd-core-dev libglvnd0 libglvnd-dev libc-dev 

# Download NVIDIA driver
# Create the NVIDIA-driver directory if it doesn't exist
if [ ! -d "/home/$USR/debian/hw-install/NVIDIA-driver" ]; then
    mkdir -p "/home/$USR/debian/hw-install/NVIDIA-driver"
fi

# Check if the NVIDIA driver file is already present in the NVIDIA-driver directory
if [ -f "/home/$USR/debian/hw-install/NVIDIA-driver/NVIDIA-Linux-x86_64-${NV_VER}.run" ]; then
    echo "NVIDIA driver file already present, skipping download."
else
    wget "https://us.download.nvidia.com/XFree86/Linux-x86_64/${NV_VER}/NVIDIA-Linux-x86_64-${NV_VER}.run" -P "/home/$USR/debian/hw-install/NVIDIA-driver" || handle_error
    chmod +x "/home/$USR/debian/hw-install/NVIDIA-driver/NVIDIA-Linux-x86_64-${NV_VER}.run"
fi


# Install NVIDIA driver
/home/$USR/debian/hw-install/NVIDIA-driver/NVIDIA-Linux-x86_64-"$NV_VER".run || handle_error


# Fix Gnome that only boot in x11 and not giving the option to select Wayland on gdm instead.
ln -sf /dev/null /etc/udev/rules.d/61-gdm.rules || handle_error

# Fix sleep, hbibernate problem and enable drm modeset /etc/default/grub.d/nvidia-options.conf
# Check if /etc/default/grub.d/nvidia-options.conf exists, if not create it and append the necessary options
if [ -f /etc/default/grub.d/nvidia-options.conf ]; then
    # Check if the lines are already present in the file
    if ! grep -q 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' /etc/default/grub.d/nvidia-options.conf; then
        echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' >> /etc/default/grub.d/nvidia-options.conf
        echo "Added 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' to /etc/default/grub.d/nvidia-options.conf"
    else
        echo "'/etc/default/grub.d/nvidia-options.conf' already contains 'options nvidia NVreg_PreserveVideoMemoryAllocations=1'"
    fi

    if ! grep -q 'options nvidia NVreg_TemporaryFilePath=/var/tmp' /etc/default/grub.d/nvidia-options.conf; then
        echo 'options nvidia NVreg_TemporaryFilePath=/var/tmp' >> /etc/default/grub.d/nvidia-options.conf
        echo "Added 'options nvidia NVreg_TemporaryFilePath=/var/tmp' to /etc/default/grub.d/nvidia-options.conf"
    else
        echo "'/etc/default/grub.d/nvidia-options.conf' already contains 'options nvidia NVreg_TemporaryFilePath=/var/tmp'"
    fi

    if ! grep -q 'options nvidia-drm modeset=1' /etc/default/grub.d/nvidia-options.conf; then
        echo 'options nvidia-drm modeset=1' >> /etc/default/grub.d/nvidia-options.conf
        echo "Added 'options nvidia-drm modeset=1' to /etc/default/grub.d/nvidia-options.conf"
    else
        echo "'/etc/default/grub.d/nvidia-options.conf' already contains 'options nvidia-drm modeset=1'"
    fi
else
    echo "Creating /etc/default/grub.d/nvidia-options.conf"
    echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' > /etc/default/grub.d/nvidia-options.conf
    echo 'options nvidia NVreg_TemporaryFilePath=/var/tmp' >> /etc/default/grub.d/nvidia-options.conf
    echo 'options nvidia-drm modeset=1' >> /etc/default/grub.d/nvidia-options.conf
fi

# Update the GRUB configuration
update-grub

# Enable necessary services
for service in nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service; do
    systemctl enable "$service" || handle_error
done

# Update initramfs
#update-initramfs -u || handle_error

# Stop timer
timer_stop

# Clear the screen and notify the user
clear
echo -e "\n\n\nInstallation completed! Press Enter to continue..."
read

# Uncomment to reboot automaticaly at the end of the installation
# shutdown -r now

# Optional checks
# sudo cat /sys/module/nvidia_drm/parameters/modeset
# sudo cat /proc/driver/nvidia/params | grep "PreserveVideoMemoryAllocations"
# glxinfo | egrep "OpenGL vendor|OpenGL renderer*"
# lsmod | grep nouveau
# lspci -nn | egrep -i "3d|display|vga"
# nvidia-smi

# To verify that NVreg_PreserveVideoMemoryAllocations is enabled, execute the following:
# cat /proc/driver/nvidia/params | sort

