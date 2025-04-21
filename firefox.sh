#!/bin/bash

# Update the package index
#sudo apt update

# Add Mozilla APT repository to sources list
echo 'deb http://download.mozilla.org/ apt stable' | sudo tee /etc/apt/sources.list.d/mozilla.list
# Import the Mozilla repository key

# Update your package list and install Firefox
apt update && apt install firefox






# Install the required dependencies
sudo apt install -y software-properties-common wget || handle_error
echo -e "\n\n\nPress Enter..."
read -r


# Download the latest Firefox package
wget -O firefox.deb https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US || handle_error
echo -e "\n\n\nPress Enter..."
read -r


# Install the Firefox package
sudo apt install -y ./firefox.deb || handle_error
echo -e "\n\n\nPress Enter..."
read -r


# Verify the installation
firefox --version

echo -e "\n\n\nPress Enter..."
read -r
