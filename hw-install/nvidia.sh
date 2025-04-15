#!/bin/bash

#2025-04-14

# nvidia.sh - Script to install NVIDIA drivers on Debian 12 - Trixie & Sid. Untested on Stable but might work.

# Execute as root
# Linux kernel 6.11 and beyond required
# Switch to the terminal view of your system by pressing Ctrl + Alt + F3.
# chmod +x nvidia.sh
# Then launch the script:   ./nvidia.sh

# Function to handle errors
handle_error() {
    echo "Error occurred in the script. Exiting."
    exit 1
}

# Start timer
timer_start

# Update package list and install necessary packages
# apt update && apt install -y linux-headers-$(uname -r) build-essential dkms libglvnd-dev pkg-config || handle_error
apt update && apt install -y linux-headers-$(uname -r) gcc make acpid dkms libvulkan1 || handle_error   #libglvnd-core-dev libglvnd0 libglvnd-dev libc-dev pkg-config

# Download NVIDIA driver
# NV_VER="570.133.07"  # Set your NVIDIA version here if you are not using install.sh to reach this script.

# Check if the NVIDIA driver file is already present
if [ -f "Linux-x86_64/${NV_VER}/NVIDIA-Linux-x86_64-${NV_VER}.run" ]; then
    echo "NVIDIA driver file already present, skipping download."
else
    wget "https://us.download.nvidia.com/XFree86/Linux-x86_64/${NV_VER}/NVIDIA-Linux-x86_64-${NV_VER}.run" || handle_error
    chmod +x "NVIDIA-Linux-x86_64-${NV_VER}.run"
fi

# Stop display manager services
#systemctl stop gdm gdm3 lightdm  # error expected



# Stop display manager services
if systemctl is-active gdm || systemctl is-active gdm3 || systemctl is-active lightdm; then
    echo "Stopping display manager services..."
    systemctl stop gdm gdm3 lightdm
else
    echo "No display manager services are running."
fi





#read -p "Press Enter to start installing NVIDIA driver ............................>>>"
# Install NVIDIA driver
./NVIDIA-Linux-x86_64-"$NV_VER".run || handle_error



# Backup and update GRUB configuration
#cp /etc/default/grub.d/nvidia-modeset.cfg /etc/default/grub.d/nvidia-modeset.cfg.$(date +%Y%m%d%H%M%S)  # error expected
#echo 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nvidia-drm.modeset=1"' > /etc/default/grub.d/nvidia-modeset.cfg
#update-grub || handle_error





# Backup and update GRUB configuration
if [ -f /etc/default/grub.d/nvidia-modeset.cfg ]; then
    echo "Backing up /etc/default/grub.d/nvidia-modeset.cfg to /etc/default/grub.d/nvidia-modeset.cfg.$TIMESTAMP"
    cp /etc/default/grub.d/nvidia-modeset.cfg /etc/default/grub.d/nvidia-modeset.cfg.$TIMESTAMP
else
    echo "Creating /etc/default/grub.d/nvidia-modeset.cfg"
fi

echo 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nvidia-drm.modeset=1"' > /etc/default/grub.d/nvidia-modeset.cfg
update-grub || handle_error

# Fix Gnome for NVIDIA
ln -sf /dev/null /etc/udev/rules.d/61-gdm.rules || handle_error

# Fix NVIDIA graphical glitches after waking from sleep
echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' >> /etc/modprobe.d/nvidia-power-management.conf
echo '#NVreg_TemporaryFilePath=/var/tmp' >> /etc/modprobe.d/nvidia-power-management.conf

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
