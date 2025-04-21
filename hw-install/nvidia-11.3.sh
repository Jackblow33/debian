#!/bin/bash

#2025-04-21
# WORKING, close to stable          TODO ADD NOUVEAU BLACKLIST + notif files modifications from 11.1
                                    # Add MangoHud https://github.com/flightlessmango/MangoHud

# nvidia.sh - Script to install NVIDIA drivers on Debian 12 - Trixie & Sid. Untested on Stable but might work.
# Linux kernel 6.11 and beyond required

# NV_VER="570.133.07"  # Uncomment to set Nvidia Driver version here if runing this script as standalone

TIMESTAMP=$(date +%Y%m%d.%R)

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
    apt update && apt install -y linux-headers-$(uname -r) gcc make acpid dkms libvulkan1 libglvnd-core-dev pkg-config || handle_error  #libglvnd0 libglvnd-dev libc-dev
}

# Download NVIDIA driver
download_nvidia_driver() {
    local driver_file="NVIDIA-Linux-x86_64-${NV_VER}.run"
    wget "https://us.download.nvidia.com/XFree86/Linux-x86_64/${NV_VER}/${driver_file}" || handle_error
    chmod +x "${driver_file}"
}

# Install NVIDIA driver
install_nvidia_driver() {
    ./"NVIDIA-Linux-x86_64-${NV_VER}.run" || handle_error
}

# Backup and update GRUB configuration with proper kernel boot flags
update_grub_config() {
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
  echo "Nouveau driver has been blacklisted. System have to be reboot for the changes to take effect."
                
                # Check if the grub file exist
                if [ -f /etc/default/grub ]; then
                  # Backup the original file
                  sudo cp /etc/default/grub /etc/default/grub.$TIMESTAMP

                  # Comment GRUB_CMDLINE_LINUX_DEFAULT
                  sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT/#GRUB_CMDLINE_LINUX_DEFAULT/' /etc/default/grub

                  # Add a new GRUB_CMDLINE_LINUX_DEFAULT with new kernel loading options
                  echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia-drm.modeset=1 intel_iommu=on"' | sudo tee -a /etc/default/grub      # Add argument "splash" To enable boot splash screen

                  # Update the GRUB configuration
                  update-grub
                else
                  echo "The file /etc/default/grub does not exist."
                fi
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
timer_start
install_dependencies
download_nvidia_driver
install_nvidia_driver
update_grub_config
fix_gnome_for_nvidia
fix_nvidia_power_management
enable_nvidia_services
update_initramfs
timer_stop

# Clear the screen and notify the user
#clear
#echo -e "\n\n\nInstallation completed! Press Enter to continue..."
#read

# Uncomment to reboot automaticaly at the end of the installation
# shutdown -r now

# Optional checks
# sudo cat /sys/module/nvidia_drm/parameters/modeset
# sudo cat /proc/driver/nvidia/params | grep "PreserveVideoMemoryAllocations"
# glxinfo | egrep "OpenGL vendor|OpenGL renderer*"
# lsmod | grep nouveau
# lspci -nn | egrep -i "3d|display|vga"
# nvidia-smi
