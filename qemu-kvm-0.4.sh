#!/bin/bash

# qemu-kvm installer - Debian - only work with Intel for now.
# Mostly based on: https://github.com/daveprowse/virtualization/blob/main/kvm/kvm-install-debian-12/kvm-install-debian-12.md
# TODO ADD ***AMD virtualisation***

# Copy before editing /etc/default/grub
GRUB_FILE="/etc/default/grub"
cp $GRUB_FILE $GRUB_FILE.$TIMESTAMP || handle_error

# Search for the line: GRUB_CMDLINE_LINUX_DEFAULT="quiet*
GRUB_LINE=$(grep -E '^GRUB_CMDLINE_LINUX_DEFAULT="quiet' "$GRUB_FILE")

# Check if the line was found
if [ -z "$GRUB_LINE" ]; then
  echo "Error: Could not find the GRUB_CMDLINE_LINUX_DEFAULT line in $GRUB_FILE."
  exit 1
fi

# Check if the intel_iommu=on argument is already present                
if grep -q 'intel_iommu=on' <<< "$GRUB_LINE"; then
  echo "The intel_iommu=on argument is already present in the GRUB_CMDLINE_LINUX_DEFAULT line."
  exit 0
fi

# Append the intel_iommu=on argument to the line
NEW_GRUB_LINE="${GRUB_LINE%\"} intel_iommu=on\""
echo "Updating the GRUB_CMDLINE_LINUX_DEFAULT line in $GRUB_FILE:"
echo "  Old line: $GRUB_LINE"
echo "  New line: $NEW_GRUB_LINE"

# Update the GRUB_CMDLINE_LINUX_DEFAULT line in the file
sed -i "s|$GRUB_LINE|$NEW_GRUB_LINE|" "$GRUB_FILE"
echo "Successfully updated the GRUB_CMDLINE_LINUX_DEFAULT line in $GRUB_FILE."


# Update the GRUB configuration
update-grub || handle_error

apt update
apt install -y qemu-kvm qemu-utils libvirt-daemon-system libvirt-clients virtinst virt-manager || error_handler

#Enable libvirtd
systemctl --now enable libvirtd || error_handler

# Check the service status:
systemctl status libvirtd || error_handler

# Add a user to the libvirt group so that it can create and modify virtual machines
usermod -aG libvirt $USR
usermod -aG libvirt-qemu $USR
usermod -aG kvm $USR
usermod -aG input $USR
usermod -aG disk $USR


# Set Virsh to autostart whenever the system is rebooted
sudo virsh net-autostart default

# Restarting the libvirtd service
systemctl restart libvirtd














# Extra checks  ####################################################
# Let's view our virsh network:
# virsh net-list

# #Run the following command to view the various components that should run in KVM:
# sudo virt-host-validate
# It is normal to have freezer FAIL and secure guest support WARN. Qemu related lines have to be green

# Check the service status:
# systemctl status libvirtd

#Check QEMU and Virsh versions:
#kvm --version
##Check that the KVM modules are loaded correctly.
#lsmod | grep kvm
#read -p "Press enter, libvirtd should be enabled now"


#lsmod | grep kvm should return:
#Sample results:
#dpro@smauggy:~$ lsmod | grep kvm
#kvm_intel             380928  0
#kvm                  1142784  1 kvm_intel
#read -p "Press enter to start"

#echo '##Cpu core count##'
#egrep -c '(vmx|svm)' /proc/cpuinfo
#echo 'Check if virtualisation is enable in bios  #Intel Cpu should read: Virtualization: VT-x'
#lscpu | grep Virtualization
#                                    add check for Intel Amd virtualisation









