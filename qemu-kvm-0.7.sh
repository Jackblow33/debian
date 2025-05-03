#!/bin/bash

# qemu-kvm-0.7.sh   - Debian - supports both Intel and AMD virtualization
# 2025-05-03
# Mostly based on: https://github.com/daveprowse/virtualization/blob/main/kvm/kvm-install-debian-12/kvm-install-debian-12.md

# Set the total number of steps
TOTAL_STEPS=9
CURRENT_STEP=0

# Copy before editing /etc/default/grub
GRUB_FILE="/etc/default/grub"
cp $GRUB_FILE $GRUB_FILE.$TIMESTAMP || error_handler

# Check if Intel or AMD virtualization is enabled
VIRTUALIZATION=$(lscpu | grep Virtualization)

if [[ $VIRTUALIZATION == *"VT-x"* ]]; then
  echo "Intel virtualization (VT-x) is enabled."
  GRUB_PARAM="intel_iommu=on"
elif [[ $VIRTUALIZATION == *"AMD-V"* ]]; then
  echo "AMD virtualization (AMD-V) is enabled."
  GRUB_PARAM="amd_iommu=on"
else
  whiptail --msgbox "Virtualization is not enabled. Virtualization have to be enable trough your bios first." 8 78
  exit 1
fi

# Search for the line: GRUB_CMDLINE_LINUX_DEFAULT="quiet*
GRUB_LINE=$(grep -E '^GRUB_CMDLINE_LINUX_DEFAULT="quiet' "$GRUB_FILE")

# Check if the line was found
if [ -z "$GRUB_LINE" ]; then
  whiptail --msgbox "Error: Could not find the GRUB_CMDLINE_LINUX_DEFAULT line in $GRUB_FILE." 8 78 || error_handler
fi

# Check if the virtualization argument is already present
if grep -q "$GRUB_PARAM" <<< "$GRUB_LINE"; then
  whiptail --msgbox "The $GRUB_PARAM argument is already present in the GRUB_CMDLINE_LINUX_DEFAULT line." 8 78
fi

# Append the virtualization argument to the line
NEW_GRUB_LINE="${GRUB_LINE%\"} $GRUB_PARAM\""
whiptail --msgbox "Updating the GRUB_CMDLINE_LINUX_DEFAULT line in $GRUB_FILE:\nOld line: $GRUB_LINE\nNew line: $NEW_GRUB_LINE" 12 78

# Update the GRUB_CMDLINE_LINUX_DEFAULT line in the file
sed -i "s|$GRUB_LINE|$NEW_GRUB_LINE|" "$GRUB_FILE"
whiptail --msgbox "Successfully updated the GRUB_CMDLINE_LINUX_DEFAULT line in $GRUB_FILE." 8 78
CURRENT_STEP=$((CURRENT_STEP + 1))

# Update the GRUB configuration
whiptail --gauge "Updating GRUB configuration..." 8 78 $((CURRENT_STEP * 100 / TOTAL_STEPS))
update-grub || error_handler
CURRENT_STEP=$((CURRENT_STEP + 1))

# Install packages
whiptail --gauge "Installing packages..." 8 78 $((CURRENT_STEP * 100 / TOTAL_STEPS))
apt update
apt install -y qemu-kvm qemu-utils libvirt-daemon-system libvirt-clients virtinst virt-manager || error_handler
CURRENT_STEP=$((CURRENT_STEP + 1))

# Enable libvirtd
whiptail --gauge "Enabling libvirtd..." 8 78 $((CURRENT_STEP * 100 / TOTAL_STEPS))
systemctl --now enable libvirtd || error_handler
CURRENT_STEP=$((CURRENT_STEP + 1))

# Add the user to the necessary groups
whiptail --gauge "Adding user to required groups..." 8 78 $((CURRENT_
