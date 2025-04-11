#!/bin/bash

# Execute as root

# FIX NVIDIA Graphical glitches and unresponsive after waking from sleep
# Source  https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend

# Next lines into file /etc/modprobe.d/nvidia-power-management.conf
  echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' >>  /etc/modprobe.d/nvidia-power-management.conf
  echo '#NVreg_TemporaryFilePath=/var/tmp' >>  /etc/modprobe.d/nvidia-power-management.conf
  nano /etc/modprobe.d/nvidia-power-management.conf

# Making sure next 3 services are enable  --options enable disable & status
#VARIABLE
OPTIONS=enable    #disable, status
  sudo systemctl $OPTIONS nvidia-suspend.service
  sudo systemctl $OPTIONS nvidia-hibernate.service
  sudo systemctl $OPTIONS nvidia-resume.service 
