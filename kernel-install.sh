vu#!/bin/bash

#KERNEL=6.14.1-tkg-eevdf


lsblk
# Enter a device name for your usb
echo ´´
echo ´´
read -p "Enter the USB device name (e.g.,  sdd1, sdc1): " usb_device_name

# Get information about the specified device
usb_device_info=$(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep "$usb_device_name")

# Check if the device was found
if [ -n "$usb_device_info" ]; then
    echo "USB device information:"
    echo "$usb_device_info"
    usb_device=/dev/$usb_device_name
    echo "USB device path: $usb_device"
else
    echo "USB device not found. Please check the device name and try again."
    exit 1
fi

    echo "Mounting USB device: $usb_device"
    sudo mkdir /mnt/usb
    sudo mount /dev/$usb_device_name /mnt/usb
    cd /mnt/usb/_MyFiles/kernels/$KERNEL
    sudo dpkg -i *.deb
    read -p "Press Enter to reboot and load kernel $KERNEL............................>>>"
    #sudo shutdown -r now




# In case your system is not booting to the new kernel, you can update initramfs and your GRUB configuration manually
#sudo update-initramfs -c -k $KERNEL
#sudo update-grub
