#!/bin/bash

# Debian Steam install


sudo dpkg --add-architecture i386 && sudo apt update
sudo apt install mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386
wget https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb -P /home/jack/Downloads || error_handler
sudo mkdir -p ~/.local/share/Steam
sudo chown -R $USER:$USER ~/.local/share/Steam
sudo apt --fix-broken install
sudo dpkg -i /home/jack/Downloads/steam.deb || error_handler
mangohud --version  #0.7.1


#sudo apt -f install || error_handler


#sudo dpkg --add-architecture i386 && sudo apt update
#apt install mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386
#sudo apt install nvidia-driver-libs:i386
#apt install steam-installer
#  https://wiki.debian.org/Steam

apt install libxnvctrl0
wget https://github.com/flightlessmango/MangoHud/releases/download/v0.8.1/MangoHud-0.8.1.r0.gfea4292.tar.gz -P /home/jack/Downloads
tar -xzf /home/jack/Downloads/MangoHud-0.8.1.r0.gfea4292.tar.gz
cd /home/jack/Downloads/MangoHud
./mangohud-setup.sh
apt install goverlay     #mangohud 
# For Steam games, you can add this as a launch option: mangohud %command%
# Or alternatively, add MANGOHUD=1 to your shell profile (Vulkan only).


#sudo apt install steam-libs-i386
#sudo mkdir -p ~/.local/share/Steam
#sudo chown -R $USER:$USER ~/.local/share/Steam
