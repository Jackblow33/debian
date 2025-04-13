
# Uninstaller for the official NVIDIA installer from the Nvidia.com website
# Source: https://github.com/oddmario/NVIDIA-Ubuntu-Driver-Guide/blob/main/README.md#uninstalling-the-driver-when-installed-through-the-official-nvidia-installer-from-the-nvidiacom-website

# To ensure that we can boot into the system graphically through the Nouveau driver after uninstalling the Nvidia driver 
# remove any Nouveau-blacklist entries that might have been created by the installer previously
  #sudo rm -rf /lib/modprobe.d/nvidia-installer-*
  sudo rm -rf /etc/modprobe.d/nvidia-power-management.conf
  sudo rm -rf /etc/modprobe.d/nvidia-installer-*
  sudo rm -rf /usr/lib/modprobe.d/nvidia-installer-*

# Remove any entries related to the NVIDIA driver (nvidia-drm.modeset, nvidia-drm.fbdev, etc) from your /etc/default/grub file. (this is important).
  rm -f /etc/default/grub.d/nvidia-modeset.*
#Rebuild the GRUB configuration file
  sudo update-grub
# Run the uninstaller
  sudo nvidia-installer --uninstall
# Rebuild the system initramfs
  sudo update-initramfs -u
  
