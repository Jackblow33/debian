#!/bin/bash

# KVM - Qemu without gpu passtrough 

#Mostly based on: https://github.com/daveprowse/virtualization/blob/main/kvm/kvm-install-debian-12/kvm-install-debian-12.md

echo '##Cpu core count##'
egrep -c '(vmx|svm)' /proc/cpuinfo
echo 'Check if virtualisation is enable in bios  #Intel Cpu should read: Virtualization: VT-x'
lscpu | grep Virtualization
#                                    add check for Intel Amd virtualisation
read -p "Press enter to start"
sudo apt update
sudo apt install qemu-kvm qemu-utils libvirt-daemon-system libvirt-clients virtinst virt-manager

#!/bin/bash

# Check if the file exists
if [ -f /etc/default/grub ]; then
    # Backup the original file
    sudo cp /etc/default/grub /etc/default/grub.$TIMESTAMP

    # Comment GRUB_CMDLINE_LINUX_DEFAULT
    sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT/#GRUB_CMDLINE_LINUX_DEFAULT/' /etc/default/grub

    # Add a new GRUB_CMDLINE_LINUX_DEFAULT with new kernel loading options
    echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=on"' | sudo tee -a /etc/default/grub

    # Update the GRUB configuration
    update-grub
else
    echo "The file /etc/default/grub does not exist."
fi



    read -p "Press enter to reboot"
    reboot


    #After rebooting, you can verify that the Intel IOMMU is enabled by checking the kernel parameters
    #cat /proc/cmdline
    #check the dmesg output for IOMMU-related messages
    #dmesg | grep -i iommu    # = DMAR: IOMMU enabled
