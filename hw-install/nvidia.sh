#!/bin/bash
#nvidia.sh

# Execute as root 
##linux kernel 6.11 and beyond required

#run the script as root
#Switch to the terminal view of your system by pressing Ctrl + Alt + F3 and then launch the script ./nvidia1.sh
#Blacklist, update system & install Nvidia driver

#VARIABLES
#TIMESTAMP=`date +%Y%m%d.%R`
#NV_VER="570.133.07" # Nvidia Driver version

#VARIABLES
# Colors
#GREEN='\033[0;32m'
#NC='\033[0m' #no color

#fonctions
#timer_start()
{
BEGIN=$(date +%s)
}

#fonctions
#timer_stop()
{
    NOW=$(date +%s)
    let DIFF=$(($NOW - $BEGIN))
    let MINS=$(($DIFF / 60))
    let SECS=$(($DIFF % 60))
    echo Time elapsed: $MINS:`printf %02d $SECS`
}


# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi


#NVIDIA Driver install for 6.11 kernel +
    timer_start
    apt update && apt upgrade
    apt-get remove --purge '^nvidia-.*'
    apt purge libnvidia-*
    apt autoremove
    apt autoremove $(dpkg -l nvidia-driver* |grep ii |awk '{print $2}')
    
    apt install pkg-config libglvnd-dev dkms build-essential libegl-dev libegl1 libgl-dev libgl1 libgles-dev libgles1 libglvnd-core-dev libglx-dev libopengl-dev gcc make pkg-config linux-headers-$(uname -r)
                      #apt install linux-headers-$(uname -r) build-essential libglvnd-dev pkg-config
                      #OLD  wget https://us.download.nvidia.com/XFree86/Linux-x86_64/570.86.16/NVIDIA-Linux-x86_64-570.86.16.run
                      #Working  apt install linux-headers-$(uname -r) gcc make acpid dkms libglvnd-core-dev libglvnd0 libglvnd-dev dracut libc-dev pkg-config
    wget https://us.download.nvidia.com/XFree86/Linux-x86_64/570.133.07/NVIDIA-Linux-x86_64-"$NV_VER".run
    chmod +x NVIDIA-Linux-x86_64-"$NV_VER".run
                      
    

# Stop the GDM service - Just in case
    sudo systemctl stop gdm
    sudo systemctl stop gdm3 || sudo systemctl stop lightdm

    read -p "Press Enter to start installing Nvidia driver ............................>>>"

    
./NVIDIA-Linux-x86_64-"$NV_VER".run
sudo update-initramfs -u
    
    cp /etc/default/grub.d/nvidia-modeset.cfg /etc/default/grub.d/nvidia-modeset.cfg.$TIMESTAMP
    rm -f /etc/default/grub.d/nvidia-modeset.cfg
    echo 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nvidia-drm.modeset=1"' >> /etc/default/grub.d/nvidia-modeset.cfg
    nano /etc/default/grub.d/nvidia-modeset.cfg
    sudo update-grub

# FIX Gnome - source https://wiki.archlinux.org/title/GDM#Wayland_and_the_proprietary_NVIDIA_driver    
    ln -s /dev/null /etc/udev/rules.d/61-gdm.rules


# FIX NVIDIA - Graphical glitches and unresponsive after waking from sleep
# Source  https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend
  echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' >>  /etc/modprobe.d/nvidia-power-management.conf
  echo '#NVreg_TemporaryFilePath=/var/tmp' >>  /etc/modprobe.d/nvidia-power-management.conf
  nano /etc/modprobe.d/nvidia-power-management.conf

# Making sure next 3 services are enable  --options enable(default), disable & status
#VARIABLE
OPTION=enable    #disable, status
  sudo systemctl $OPTION nvidia-suspend.service
  sudo systemctl $OPTION nvidia-hibernate.service
  sudo systemctl $OPTION nvidia-resume.service 
       echo
       echo
       echo
# Error check
    if [ $? -ne 0 ]; then
       echo "Driver install successfully." #>> $LOGFILE
       timer_stop
       read -p "$(echo -e $GREEN"Driver $NV_VER install successfully."$NC)"
       
    else
       echo "Install did not run successfully"; press_enter; exit 1
    fi

   echo ''
   echo ''
   echo ''
   read -p "$(echo -e $GREEN"Installation completed! Press Enter to reboot............................>>> "$NC)"
    #sudo shutdown -r now    #reboot


    
    
    
    
    
    
    #sudo cat /sys/module/nvidia_drm/parameters/modeset   #Y is expected nvidia-drm modeset is enable
    #nvidia-smi

    #If you plan to use suspend/hibernate functionality under KDE desktop environment, you may want to add another option to avoid graphics "glitches" after wakeup/restore:
### Warning: skip this step if you have Optimus hybrid graphics
#sudo echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" >> /etc/modprobe.d/nvidia-options.conf






#Blacklist Nouveau driver ---DISABLE--- Nvidia installer seems to do it properly
    #cp /etc/modprobe.d/blacklist-nvidia-nouveau.conf /etc/modprobe.d/blacklist-nvidia-nouveau.conf.$TIMESTAMP
    #bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    #bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    #cat <<EOF | sudo tee /etc/modprobe.d/blacklist-nvidia-nouveau.conf 
    #> blacklist nouveau
    #> options nouveau modeset =0
    #>EOF
    #or /etc/modprobe.d/blacklist-nouveau.conf
    update-initramfs -u
#reboot




    
    
    #UBUNTU references
    #echo "Once the installer has completed installing the driver, run sudo update-initramfs -u to update the initramfs."
    ###echo "Edit /etc/default/grub using sudo nano /etc/default/grub"
    ###echo 'Add nvidia-drm.modeset=1 and nvidia-drm.fbdev=1 inside your GRUB_CMDLINE_LINUX (i.e. GRUB_CMDLINE_LINUX="nvidia-drm.modeset=1 nvidia-drm.fbdev=1")'
    #echo 'Need to add the nvidia-drm.modeset=1 to the grub config for your kernel. Create the file /etc/default/grub.d/nvidia-modeset.cfg'
    #echo 'Add the line:'
    #echo 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nvidia-drm.modeset=1"'
    #echo "Run sudo update-grub"
    #echo "Reboot the system"
    #echo "Your newly installed driver should be up and running once the system boots up (you may run nvidia-smi to confirm so)."
    #read -p "Press    -Enter-   ............................>>>"
#Source https://github.com/oddmario/NVIDIA-Ubuntu-Driver-Guide/tree/main?tab=readme-ov-file#installing-through-the-official-nvidia-installer-from-the-nvidiacom-website








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
