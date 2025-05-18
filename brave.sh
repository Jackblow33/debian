#!/bin/bash

# Brave web browser install. Debian, Ubuntu, Mint - 2025-05-14


apt install -y curl
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
apt update -y
apt install -y brave-browser

# Keyring quirk fix
# apt purge -y gnome-keyring && apt autoremove -y
# sed -i 's|/usr/bin/brave-browser-stable|/usr/bin/brave-browser-stable --password-store=gnome|g' /usr/share/applications/brave-browser.desktop
