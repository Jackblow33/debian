#!/bin/bash

# Debian Steam install


#curl -s http://repo.steampowered.com/steam/archive/stable/steam.gpg | sudo tee /usr/share/keyrings/steam.gpg > /dev/null || error_handler
#echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/steam.gpg] http://repo.steampowered.com/steam/ stable steam' | sudo tee /etc/apt/sources.list.d/steam.list || error_handler
#apt update && apt install steam || error_handler

#wget https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb -P /home/$USR/Downloads || error_handler
#sudo dpkg -i /home/$USR/Downloads/steam.deb || error_handler
#sudo apt -f install || error_handler

dpkg --add-architecture i386; apt update
sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386



sudo apt update
sudo apt install software-properties-common apt-transport-https
sudo add-apt-repository non-free
sudo apt install -y steam-installer
