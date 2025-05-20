#!/bin/bash

#2025-04-22
# WORKING, close to stable          
# TODO - ADD CHECK IF NV HAVE BLACKLIST NOUVEAU ALREADY. Add MangoHud https://github.com/flightlessmango/MangoHud

# nvidia.sh - Script to install NVIDIA drivers on Debian 12 - Trixie & Sid. Untested on Stable but might work.
# Linux kernel 6.11 and beyond required

clear
echo -e "\n\n\n\n\n\n\n\n\n\n"
echo -e '\033[1;31mTo blacklist nouveau driver the file etc/modprobe.d/blacklist-nouveau.conf gonna be created.\033[0m'
echo -e '\033[1;31mTo fix some power management issue the file etc/modprobe.d/nvidia-power-management.conf gonna be created.\033[0m'
echo -e '\033[1;31mnvidia-drm.modeset=1 gonna be added to grub at line: GRUB_CMDLINE_LINUX_DEFAULT in /etc/default\033[0m'
echo -e "\033[1;31mAnd of course you're gonna taint your kernel with the nvidia proprietary driver\033[0m"
echo -e "\n\n\n"
read -p "Press Enter to continue or 'x' to exit: " input
if [ "$input" = "x" ]; then
    exit
else
    echo "Continuing..."
fi

# Get the username dynamic variable
USR=$(logname)


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



# Blacklist nouveau, backup and update GRUB configuration with new kernel boot flags
update_grub_config() {
# Check if the blacklist entries are there, if not add them
    if ! grep -q "blacklist nouveau" "/etc/modprobe.d/blacklist-nouveau.conf"; then
    echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf
    fi
    if ! grep -q "options nouveau modeset=0" "/etc/modprobe.d/blacklist-nouveau.conf"; then
        echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
    fi
    echo "Nouveau driver has been blacklisted. System have to be reboot for the changes to take effect."
                




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
timer_start
install_dependencies
download_nvidia_driver
install_nvidia_driver
update_grub_config
fix_gnome_for_nvidia
fix_nvidia_power_management
enable_nvidia_services
# update_initramfs
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
# lsmod | grep nouveau || echo 'Nouveau NVIDIA driver have been blacklisted'
# glxinfo | egrep "OpenGL vendor|OpenGL renderer*"
# lspci -nn | egrep -i "3d|display|vga"
# nvidia-smi
