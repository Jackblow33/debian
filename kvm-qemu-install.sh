#!/bin/bash

######################################
# KVM - Qemu without gpu passtrough ##
######################################
#Mostly based on: https://github.com/daveprowse/virtualization/blob/main/kvm/kvm-install-debian-12/kvm-install-debian-12.md


echo '##Cpu core count##'
egrep -c '(vmx|svm)' /proc/cpuinfo
echo 'Check if virtualisation is enable in bios  #Intel Cpu should read: Virtualization: VT-x'
lscpu | grep Virtualization
#                                    add check for Intel Amd virtualisation
read -p "Press enter to start"
sudo apt update
sudo apt install qemu-kvm qemu-utils libvirt-daemon-system libvirt-clients virtinst virt-manager
read -p "Press enter to start"


# Append iommu in grub
# Backup the original /etc/default/grub file
cp /etc/default/grub /etc/default/grub.bak

# Edit the /etc/default/grub file
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="$.*$"/GRUB_CMDLINE_LINUX_DEFAULT="\1 intel_iommu=on"/' /etc/default/grub
update-grub
echo "The /etc/default/grub file has been updated with 'intel_iommu=on' added to the GRUB_CMDLINE_LINUX_DEFAULT variable."

#Enable libvirtd
systemctl --now enable libvirtd
read -p "Press enter to start"

##Check the service status:
systemctl status libvirtd
# Ctrl+c to exit
#Check QEMU and Virsh versions:
kvm --version
##Check that the KVM modules are loaded correctly.
lsmod | grep kvm
read -p "Press enter, libvirtd should be enabled now"


#lsmod | grep kvm should return:
#Sample results:
#dpro@smauggy:~$ lsmod | grep kvm
#kvm_intel             380928  0
#kvm                  1142784  1 kvm_intel
read -p "Press enter to start"

##Run the following command to view the various components that should run in KVM:
sudo virt-host-validate
#It is normal to have freezer FAIL and secure guest support WARN. Qemu related lines have to be green.
read -p "Press enter to start"

# Add a user to the libvirt group so that it can create and modify virtual machines.
sudo usermod -aG libvirt $USR
#sudo usermod -aG libvirt-qemu $USR
#sudo usermod -aG kvm $USR
#sudo usermod -aG input $USR
#sudo usermod -aG disk $USR
read -p "Press enter to start"

##And, set it to autostart whenever the system is rebooted.
sudo virsh net-autostart default
read -p "Press enter to start"

#Type the following command:
#sudo virsh net-list

#Now apply the changes. These can be applied by restarting the libvirtd service or by restarting the computer.
systemctl restart libvirtd
read -p "Press enter to start"

##Now, let's view our KVM networks again:
#sudo virsh net-list
echo "The GRUB configuration has been updated. Please reboot your system for the changes to take effect."
read -p "Press enter to reboot"
#reboot







