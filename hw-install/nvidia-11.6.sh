#!/bin/bash

#2025-05-01
# WORKING, close to stable          
# TODO - ADD CHECK IF NV HAVE BLACKLIST NOUVEAU ALREADY. Add MangoHud https://github.com/flightlessmango/MangoHud

# nvidia.sh - Script to install NVIDIA drivers on Debian 13 - Trixie & Sid. Untested on Stable but might work.
# Linux kernel 6.11 and beyond required

USR=$(logname)
NV_VER="570.133.07"  # Default Nvidia Driver version 
TIMESTAMP=$(date +%Y%m%d.%R)

# Display the NVIDIA driver installation warning!
display_nvidia_warning() {
    local MESSAGE="To blacklist nouveau driver, the file: /etc/modprobe.d/blacklist-nouveau.conf gonna be created.\n\n\n\
To fix some power management issues, the file: /etc/modprobe.d/nvidia-power-management.conf gonna be created.\n\n\n\
nvidia-drm.modeset=1 gonna be added to grub at line: GRUB_CMDLINE_LINUX_DEFAULT in /etc/default.\n\n\n\
And of course you're gonna taint your kernel with the nvidia proprietary driver!!!\n\n\n\
Would you like to continue? Yes or No."

    # Display the message in a yes/no dialog
    if (whiptail --title "NVIDIA Driver Installation Warning" --yesno "$MESSAGE" 24 70); then
        echo "User chose to continue."
        # Add commands here to create the files and modify grub if needed
    else
        echo "User chose not to continue."
        exit 1
    fi
}


# Function to handle errors
handle_error() {
    echo "Error occurred in the script. Exiting."
    exit 1
}

timer_start() {
    BEGIN=$(date +%s)
}

timer_stop() {
    NOW=$(date +%s)
    DIFF=$((NOW - BEGIN))
    MINS=$((DIFF / 60))
    SECS=$((DIFF % 60))
    echo "Time elapsed: $MINS:$(printf %02d $SECS)"
}

# Update package list and install necessary packages
install_dependencies() {
    apt update && apt install -y linux-headers-$(uname -r) gcc make acpid dkms libvulkan1 libglvnd-core-dev pkg-config wget || handle_error  #libglvnd0 libglvnd-dev libc-dev
}

# Download NVIDIA driver
download_nvidia_driver() {
    local driver_file="NVIDIA-Linux-x86_64-${NV_VER}.run"
    # Check if the driver file already exists
    if [ -f "$driver_file" ]; then
        echo "The driver file '$driver_file' already exist. Skipping download."
    else
        wget "https://us.download.nvidia.com/XFree86/Linux-x86_64/${NV_VER}/${driver_file}" || handle_error
        chmod +x "${driver_file}"
    fi
}

# Install NVIDIA driver
install_nvidia_driver() {
    ./"NVIDIA-Linux-x86_64-${NV_VER}.run" || handle_error
}


# Blacklist Nouveau driver
blacklist_nouveau() {
# Check if the /etc/modprobe.d/nvidia-installer-disable-nouveau.conf have already been created by nvidia installer
if [ -f "/etc/modprobe.d/nvidia-installer-disable-nouveau.conf" ]; then
    echo "File /etc/modprobe.d/nvidia/installer-disable-nouveau.conf already exists"
else
    # Check if the blacklist entries are in blacklist-nouveau.conf, if not add them
    if ! grep -q "blacklist nouveau" "/etc/modprobe.d/blacklist-nouveau.conf"; then
        echo "blacklist nouveau" | sudo tee -a "/etc/modprobe.d/blacklist-nouveau.conf"
    fi
    if ! grep -q "options nouveau modeset=0" "/etc/modprobe.d/blacklist-nouveau.conf"; then
        echo "options nouveau modeset=0" | sudo tee -a "/etc/modprobe.d/blacklist-nouveau.conf"
    fi
    echo "Nouveau driver has been blacklisted. System have to be reboot later on for the changes to take effect"
fi
}


# Add grub entries including iommu used by qemu-kvm virtualization
edit_grub_config() {
# Copy before editing /etc/default/grub file.
    sudo cp /etc/default/grub /etc/default/grub.BAK_OG_$TIMESTAMP || handle_error
# Disable original GRUB_CMDLINE_LINUX_DEFAULT line.
    sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT/#GRUB_CMDLINE_LINUX_DEFAULT/' /etc/default/grub || handle_error
# Add a new GRUB_CMDLINE_LINUX_DEFAULT with options: nvidia-drm.modeset=1        # and intel_iommu=on_(use for virtualisation)
                  #OLD  #echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia-drm.modeset=1 intel_iommu=on"' | sudo tee -a /etc/default/grub || handle_error   # Add argument "splash" To enable boot splash screen
    echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia-drm.modeset=1"' | sudo tee -a /etc/default/grub || handle_error   # Add argument "splash" To enable boot splash screen
# Update the GRUB configuration
    update-grub || handle_error
              
# Checking the kernel boot arguments added to command line
    # cat /proc/cmdline

}


# Fix Gnome for NVIDIA
fix_gnome_for_nvidia() {
    ln -sf /dev/null /etc/udev/rules.d/61-gdm.rules || handle_error
}

# Fix NVIDIA graphical glitches after waking from sleep
fix_nvidia_power_management() {
    local config_file="/etc/modprobe.d/nvidia-power-management.conf"
    if ! grep -q 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' "$config_file"; then
        echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' >> "$config_file"
    fi
    if ! grep -q '#NVreg_TemporaryFilePath=/var/tmp' "$config_file"; then
        echo '#NVreg_TemporaryFilePath=/var/tmp' >> "$config_file"
    fi
}

# Enable necessary services
enable_nvidia_services() {
    for service in nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service; do
        systemctl enable "$service" || handle_error
    done
}

# Update initramfs
update_initramfs() {
    update-initramfs -u || handle_error
}

# Main script execution
display_nvidia_warning
timer_start
install_dependencies
download_nvidia_driver
install_nvidia_driver
blacklist_nouveau
edit_grub_config
fix_gnome_for_nvidia
fix_nvidia_power_management
enable_nvidia_services
# update_initramfs
timer_stop
# clear

# Clear the screen and notify the user
#clear
#echo -e "\n\n\nInstallation completed! Press Enter to continue..."
#read

# Uncomment to reboot automaticaly at the end of the installation
# shutdown -r now

# Optional checks
# sudo cat /sys/module/nvidia_drm/parameters/modeset
# sudo cat /proc/driver/nvidia/params | grep "PreserveVideoMemoryAllocations"
# lsmod | grep nouveau || echo 'Nouveau NVIDIA driver have been blacklisted'
# glxinfo | egrep "OpenGL vendor|OpenGL renderer*"
# lspci -nn | egrep -i "3d|display|vga"
# nvidia-smi
