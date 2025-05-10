#!/bin/bash

# Debian Steam install



wget https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb -P /home/jack/Downloads || error_handler
sudo dpkg -i /home/jack/Downloads/steam.deb || error_handler
apt --fix-broken install -y
sudo mkdir -p ~/.local/share/Steam
sudo chown -R $USER:$USER ~/.local/share/Steam
#sudo apt -f install || error_handler


#sudo dpkg --add-architecture i386 && sudo apt update
#apt install mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386
#sudo apt install nvidia-driver-libs:i386
#apt install steam-installer
#  https://wiki.debian.org/Steam

# apt install mangohud libxnvctrl0 goverlay
# For Steam games, you can add this as a launch option: mangohud %command%
# Or alternatively, add MANGOHUD=1 to your shell profile (Vulkan only).


#sudo apt install steam-libs-i386
#sudo mkdir -p ~/.local/share/Steam
#sudo chown -R $USER:$USER ~/.local/share/Steam
