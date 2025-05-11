#!/bin/bash

# Debian Steam install


sudo dpkg --add-architecture i386 && sudo apt update
sudo apt install mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386
wget https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb -P /home/jack/Downloads || error_handler
sudo mkdir -p ~/.local/share/Steam
sudo chown -R $USER:$USER ~/.local/share/Steam
# sudo apt --fix-broken install
sudo apt install libutempter0  xterm
sudo dpkg -i /home/jack/Downloads/steam.deb || error_handler
mangohud --version  #0.7.1


#sudo apt -f install || error_handler


#sudo dpkg --add-architecture i386 && sudo apt update
#apt install mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386
#sudo apt install nvidia-driver-libs:i386
#apt install steam-installer
#  https://wiki.debian.org/Steam

apt install libxnvctrl0
##	sudo apt install gcc g++ gcc-multilib g++-multilib ninja-build meson python3-mako python3-setuptools python3-wheel pkg-config mesa-common-dev libx11-dev libxnvctrl-dev libdbus-1-dev python3-numpy python3-matplotlib libxkbcommon-dev libxkbcommon-dev:i386 libwayland-dev libwayland-dev:i386
git clone https://github.com/flightlessmango/MangoHud.git
cd MangoHud
chmod +x *.sh
./build.sh build
./build.sh install
apt install goverlay
# For Steam games, you can add this as a launch option: mangohud %command%
# Or alternatively, add MANGOHUD=1 to your shell profile (Vulkan only).


#sudo apt install steam-libs-i386
#sudo mkdir -p ~/.local/share/Steam
#sudo chown -R $USER:$USER ~/.local/share/Steam
