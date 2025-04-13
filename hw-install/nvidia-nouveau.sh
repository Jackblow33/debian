#!/bin/bash

# Install Nouveau Driver on Debian 12


  sudo apt update && sudo apt upgrade
# Install the necessary packages for Nouveau
  sudo apt install xserver-xorg-video-nouveau libdrm-nouveau2 libdrm-nouveau-dev
# NVIDIA proprietary driver removal
  sudo apt-get purge nvidia*
  sudo apt-get autoremove
# Blacklist the NVIDIA kernel module
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
