#!/bin/bash

#2025-04-14

# Define the kernel version (uncomment and set the desired version if not using install.sh to reach this script)
# KERNEL="6.14.1-tkg-eevdf"

# Display block devices
lsblk

# Prompt user for USB device name
echo -e "\n\n"
read -p "Enter the USB device name (e.g., sdd1, sdc1): " usb_device_name

# Get information about the specified device
usb_device_info=$(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep "$usb_device_name")

# Check if the device was found
if [ -n "$usb_device_info" ]; then
    echo "USB device information:"
    echo "$usb_device_info"
    usb_device="/dev/$usb_device_name"
    echo "USB device path: $usb_device"
else
    echo "USB device not found. Please check the device name and try again."
    exit 1
fi

# Start timer
timer_start

# Mount the USB device
echo "Mounting USB device: $usb_device"
mkdir -p /mnt/usb
if mount "$usb_device" /mnt/usb; then
    echo "USB device mounted successfully."
else
    echo "Failed to mount USB device. Please check the device and try again."
    exit 1
fi

# Change to the directory containing the kernel files
if [ -d "/mnt/usb/_MyFiles/kernels/$KERNEL" ]; then
    cd "/mnt/usb/_MyFiles/kernels/$KERNEL" || handle_error
    echo "Installing kernel packages..."
    dpkg -i *.deb || handle_error
    cd $HOME
else
    echo "Kernel directory not found: /mnt/usb/_MyFiles/kernels/$KERNEL"
    exit 1
fi

# Stop timer
timer_stop

# Prompt user to reboot
# echo -e "\n\n"
# read -p "Press Enter to reboot and load kernel $KERNEL............................>>>"
# Uncomment the following line to reboot
#sudo shutdown -r now

# Optional: Update initramfs and GRUB configuration if needed
# Uncomment the following lines if the system does not boot to the new kernel
# sudo update-initramfs -c -k "$KERNEL"
# sudo update-grub


# In case your system is not booting to the new kernel, you can update initramfs and your GRUB configuration manually
#sudo update-initramfs -c -k $KERNEL
#sudo update-grub
