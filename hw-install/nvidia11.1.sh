#!/bin/bash

#2025-04-18

# nvidia.sh - Script to install NVIDIA drivers on Debian 12 - Trixie & Sid. Untested on Stable but might work.

# Execute as root
# Linux kernel 6.11 and beyond required
# chmod +x nvidia.sh
# Then launch the script:   ./nvidia.sh

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

# Function to handle errors
handle_error() {
    echo "Error occurred in the script. Exiting."
    exit 1
}

# Start timer
timer_start() {
    start_time=$(date +%s)
}

timer_stop() {
    end_time=$(date +%s)
    echo "Script execution time: $((end_time - start_time)) seconds"
}

# Update package list and install necessary packages
install_dependencies() {
    apt update && apt install -y linux-headers-$(uname -r) gcc make acpid dkms libvulkan1 || handle_error        #libglvnd-core-dev libglvnd0 libglvnd-dev libc-dev pkg-config 
}

# Create a directory for NVIDIA drivers
create_driver_directory() {
    USR=$(logname) 
    local driver_dir="/home/$USR/debian/hw-install/nvidia-drivers"
    mkdir -p "$driver_dir" || handle_error
    echo "Driver directory created at: $driver_dir"
}

# Download NVIDIA driver
download_nvidia_driver() {
    local nv_ver="${1:-570.133.07}"  # Default NVIDIA version
    local driver_file="NVIDIA-Linux-x86_64-${nv_ver}.run"
    USR=$(logname) 
    local driver_dir="/home/$USR/debian/hw-install/nvidia-drivers"

    # Create the driver directory
    create_driver_directory

    # Check if the driver file already exists in the specified directory
    if [ -f "${driver_dir}/${driver_file}" ]; then
        echo "Driver file '${driver_file}' already exists in '${driver_dir}'. Skipping download."
    else
        wget -P "$driver_dir" "https://us.download.nvidia.com/XFree86/Linux-x86_64/${nv_ver}/${driver_file}" || handle_error
        chmod +x "${driver_dir}/${driver_file}"
    fi
}


# Install NVIDIA driver
install_nvidia_driver() {
    local driver_file="$1"
    ./"${driver_file}" || handle_error
}


# Backup, add drm.modeset=1 and update GRUB configuration
update_grub_config() {
    local backup_file="/etc/default/grub.d/nvidia-modeset.cfg.$(date +%Y%m%d%H%M%S)"
    cp /etc/default/grub.d/nvidia-modeset.cfg "${backup_file}"
    echo 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nvidia-drm.modeset=1"' > /etc/default/grub.d/nvidia-modeset.cfg
    update-grub || handle_error
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
install_nvidia_driver "NVIDIA-Linux-x86_64-${NV_VER}.run"
update_grub_config
fix_gnome_for_nvidia
fix_nvidia_power_management
enable_nvidia_services
update_initramfs
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
