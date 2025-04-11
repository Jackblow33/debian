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


#Enable libvirtd
systemctl --now enable libvirtd

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


##Run the following command to view the various components that should run in KVM:
sudo virt-host-validate
#It is normal to have freezer FAIL and secure guest support WARN. Qemu related lines have to be green.


# Add a user to the libvirt group so that it can create and modify virtual machines.
sudo usermod -aG libvirt $USER
#sudo usermod -aG libvirt-qemu $USER
#sudo usermod -aG kvm $USER
#sudo usermod -aG input $USER
#sudo usermod -aG disk $USER

##And, set it to autostart whenever the system is rebooted.
sudo virsh net-autostart default

#Type the following command:
#sudo virsh net-list

#Now apply the changes. These can be applied by restarting the libvirtd service or by restarting the computer.
systemctl restart libvirtd

##Now, let's view our KVM networks again:
#sudo virsh net-list
read -p "Reboot"
reboot








