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

##	sudo apt install gcc g++ gcc-multilib g++-multilib ninja-build meson python3-mako python3-setuptools python3-wheel pkg-config mesa-common-dev libx11-dev libxnvctrl-dev libdbus-1-dev python3-numpy python3-matplotlib libxkbcommon-dev libxkbcommon-dev:i386 libwayland-dev libwayland-dev:i386
sudo apt install libxnvctrl0
cd /home/jack/Downloads
git clone https://github.com/flightlessmango/MangoHud.git
cd MangoHud
./build.sh build
./build.sh install

               #sudo apt install lazarus-4.0
# Lazarus compilation
sudo apt-get install fpc
cd /usr/local/bin
git clone https://gitlab.com/freepascal.org/lazarus/lazarus.git
cd lazarus
make clean all
# make clean bigide


               #sudo apt install goverlay
# Goverlay compilation
sudo apt-get install libqt6pas-dev vulkan-tools mesa-utils vkbasalt
cd /home/jack/Downloads
git clone https://github.com/benjamimgois/goverlay.git
cd goverlay
sudo make
make install






# For Steam games, you can add this as a launch option: mangohud %command%
# Or alternatively, add MANGOHUD=1 to your shell profile (Vulkan only).


#sudo apt install steam-libs-i386
#sudo mkdir -p ~/.local/share/Steam
#sudo chown -R $USER:$USER ~/.local/share/Steam
