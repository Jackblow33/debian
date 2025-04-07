#!/bin/bash

#CachyOS Nvidia ver = 570.133.07 -  Mar 18, 2025
##kernel 6.11 and beyond

#run the script as root
#Blacklist, update system & install Nvidia driver

#VARIABLES
TIMESTAMP=`date +%Y%m%d.%R`


#Blacklist Nouveau driver
    cp /etc/modprobe.d/blacklist-nvidia-nouveau.conf /etc/modprobe.d/blacklist-nvidia-nouveau.conf.$TIMESTAMP
    bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    #cat <<EOF | sudo tee /etc/modprobe.d/blacklist-nvidia-nouveau.conf 
    #> blacklist nouveau
    #> options nouveau modeset =0
    #>EOF
    #or /etc/modprobe.d/blacklist-nouveau.conf
    update-initramfs -u
#reboot

#NVIDIA Driver install for 6.11 kernel +
    apt update && apt upgrade
    apt autoremove $(dpkg -l nvidia-driver* |grep ii |awk '{print $2}')
    apt install linux-headers-$(uname -r) gcc make acpid dkms libglvnd-core-dev libglvnd0 libglvnd-dev dracut libc-dev
    #apt install linux-headers-$(uname -r) build-essential libglvnd-dev pkg-config
    #wget https://us.download.nvidia.com/XFree86/Linux-x86_64/570.86.16/NVIDIA-Linux-x86_64-570.86.16.run
    wget https://us.download.nvidia.com/XFree86/Linux-x86_64/570.133.07/NVIDIA-Linux-x86_64-570.133.07.run
    chmod +x NVIDIA-Linux-x86_64-570.86.16.run
./NVIDIA-Linux-x86_64-570.86.16.run










#For Debian Trixie           OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD
#NV Version 535.216.03

#Source https://wiki.debian.org/NvidiaGraphicsDrivers

#GPU Identification
#lspci -nn | egrep -i "3d|display|vga"

#Check for driver version before installing
# If driver: nouveau. Then you have open sources driver. Update might be a good idea...
#lspci -v

#Add contrib non-free & non-free-firmware components to /etc/apt/sources.list

#detect gpu and suggest drivers
#sudo apt install nvidia-detect
#nvidia-detect

#If your system uses dracut  - NOT in my case
#Make a dracut configuration file /etc/dracut.conf.d/10-nvidia.conf with this
#install_items+=" /etc/modprobe.d/nvidia-blacklists-nouveau.conf /etc/modprobe.d/nvidia.conf /etc/modprobe.d/nvidia-options.conf "

#sudo apt update
#To install "proprietary" flavor, packages 
sudo apt install nvidia-kernel-dkms nvidia-driver firmware-misc-nonfree
#To install "open" flavor,
#sudo apt install nvidia-open-kernel-dkms nvidia-driver firmware-misc-nonfree
#DKMS will build the nvidia module for your system

#Restart your system to load the new driver

#wayland desktop
#sudo cat /sys/module/nvidia_drm/parameters/modeset
#If this command returns N you need to set nvidia-drm modeset by adding options nvidia-drm modeset=1 to /etc/modprobe.d/nvidia-options.conf. For example
#sudo echo "options nvidia-drm modeset=1" >> /etc/modprobe.d/nvidia-options.conf


#If you plan to use suspend/hibernate functionality under KDE desktop environment, you may want to add another option to avoid graphics "glitches" after wakeup/restore:
### Warning: skip this step if you have Optimus hybrid graphics
#sudo echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" >> /etc/modprobe.d/nvidia-options.conf

#Then reboot your system (check again if modeset is properly set, as described above) and Nvidia card should be properly recognized and used under wayland desktop.
