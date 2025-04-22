#!/bin/bash

# Debian Steam install


curl -s http://repo.steampowered.com/steam/archive/stable/steam.gpg | sudo tee /usr/share/keyrings/steam.gpg > /dev/null || error_handler
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/steam.gpg] http://repo.steampowered.com/steam/ stable steam' | sudo tee /etc/apt/sources.list.d/steam.list || error_handler
apt update && apt install steam || error_handler
