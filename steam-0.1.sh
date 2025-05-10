#!/bin/bash

# Debian Steam install


#apt --fix-broken install -y
#wget https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb -P /home/$USR/Downloads || error_handler
#sudo dpkg -i /home/$USR/Downloads/steam.deb || error_handler
#sudo apt -f install || error_handler


sudo dpkg --add-architecture i386 && sudo apt update
apt install mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386
sudo apt install nvidia-driver-libs:i386
apt install steam-installer
#  https://wiki.debian.org/Steam

# apt install mangohud libxnvctrl0
# For Steam games, you can add this as a launch option: mangohud %command%
