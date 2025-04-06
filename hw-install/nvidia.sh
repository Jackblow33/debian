#For Debian Trixie
#NV Version 535.216.03

#Source https://wiki.debian.org/NvidiaGraphicsDrivers

#GPU Identification
lspci -nn | egrep -i "3d|display|vga"

#Check for driver version before installing
# If driver: nouveau. Then you have open sources driver. Update might be a good idea...
lspci -v

#Add contrib non-free & non-free-firmware components to /etc/apt/sources.list

#detect gpu and suggest drivers
sudo apt install nvidia-detect
nvidia-detect

#If your system uses dracut  - NOT in my case
#Make a dracut configuration file /etc/dracut.conf.d/10-nvidia.conf with this
#install_items+=" /etc/modprobe.d/nvidia-blacklists-nouveau.conf /etc/modprobe.d/nvidia.conf /etc/modprobe.d/nvidia-options.conf "

sudo apt update
#To install "proprietary" flavor, packages 
sudo apt install nvidia-kernel-dkms nvidia-driver firmware-misc-nonfree
#To install "open" flavor,
#sudo apt install nvidia-open-kernel-dkms nvidia-driver firmware-misc-nonfree
#DKMS will build the nvidia module for your system

#Restart your system to load the new driver

#wayland desktop
sudo cat /sys/module/nvidia_drm/parameters/modeset
If this command returns N you need to set nvidia-drm modeset by adding options nvidia-drm modeset=1 to /etc/modprobe.d/nvidia-options.conf. For example
sudo echo "options nvidia-drm modeset=1" >> /etc/modprobe.d/nvidia-options.conf


#If you plan to use suspend/hibernate functionality under KDE desktop environment, you may want to add another option to avoid graphics "glitches" after wakeup/restore:
### Warning: skip this step if you have Optimus hybrid graphics
sudo echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" >> /etc/modprobe.d/nvidia-options.conf

#Then reboot your system (check again if modeset is properly set, as described above) and Nvidia card should be properly recognized and used under wayland desktop.
