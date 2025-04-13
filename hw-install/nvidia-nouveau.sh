#!/bin/bash

# Uninstall previous driver and install Nouveau Driver on Debian 12


  sudo apt update && sudo apt upgrade
# Install the necessary packages for Nouveau
  sudo apt install xserver-xorg-video-nouveau libdrm-nouveau2 libdrm-nouveau-dev   # Error: Unable to locate package libdrm-nouveau-dev ???
# NVIDIA proprietary driver removal
  #sudo apt autoremove nvidia* --purge
  #sudo /usr/bin/nvidia-uninstall
  sudo apt-get purge nvidia*
  sudo apt-get autoremove
# Blacklist the NVIDIA kernel module
  sudo rm -f /etc/modprobe.d/nvidia*    # delete nvidia* config files from previous install
  sudo rm -f /etc/modprobe.d/blacklist-nvidia.conf delete if present and generate a new one
  echo 'blacklist nvidia' >> /etc/modprobe.d/blacklist-nvidia.conf
  echo 'blacklist nvidia-modeset' >> /etc/modprobe.d/blacklist-nvidia.conf
  echo 'blacklist nvidia-drm' >> /etc/modprobe.d/blacklist-nvidia.conf
  echo 'blacklist nvidia-uvm' >> /etc/modprobe.d/blacklist-nvidia.conf
  echo 'blacklist nouveau' >> /etc/modprobe.d/blacklist-nvidia.conf
  echo 'options nouveau modeset=0' >> /etc/modprobe.d/blacklist-nvidia.conf
  sudo nano /etc/modprobe.d/blacklist-nvidia.conf
  sudo update-initramfs -u
  echo "Press [enter] to reboot"; read enterKey
  sudo shutdown -r now      #reboot

  # After rebooting, the Nouveau driver should be loaded automatically.
  # If you encounter any issues, you can check the Xorg logs for more information
    #cat /var/log/Xorg.0.log

  # Check
    #cat /proc/driver/nvidia/version
    #cat /sys/module/nvidia/version
    #lsmod | grep nouveau


# Second test doesn't seems to work.
# Here's a step-by-step guide:
# 1. Check if nouveau is loaded:
# Open a terminal and run: 
  #lsmod | grep -i nouveau.
#If the output contains "nouveau", it means the nouveau driver is loaded.
#If the output is empty, the nouveau driver is not loaded. 
# 2. Blacklist the NVIDIA driver (if it's still present):
# If necessary, create or edit a blacklist file:
# Create a new file in /etc/modprobe.d/ with a descriptive name, like blacklist-nvidia.conf.
# Add the following line to the file: blacklist nvidiafb.
# Add the following line to the file: blacklist nouveau.
# Apply the blacklist to unload the modules.
  #sudo modprobe -r nvidiafb
  #sudo modprobe -r nouveau 
# Run sudo update-initramfs -u to update the initial ramdisk. 
# 3. Ensure nouveau is loaded:
# If nouveau is not loaded, install the nouveau package: sudo apt-get install xserver-xorg-video-nouveau.
# Restart your system: This ensures the changes are applied. 
# 4. Verify nouveau is loaded:
# After restarting, run lsmod | grep -i nouveau again.
# The output should now contain "nouveau", confirming it's loaded. 
# Explanation:
# Blacklisting: Blacklisting prevents a module from loading during system boot. In this case, we blacklist nvidiafb and nouveau to ensure the NVIDIA driver is not loaded and the nouveau driver is not inadvertently loaded alongside the NVIDIA driver.
# sudo modprobe -r: This command removes a kernel module from memory.
# sudo update-initramfs -u: This updates the initial ramdisk, which is a file system that is loaded before the root file system. This is necessary to ensure that the changes made to the blacklist are picked up during boot. 
# By following these steps, you should be able to successfully disable the NVIDIA proprietary driver and enable the open-source nouveau driver in Debian 12. 
