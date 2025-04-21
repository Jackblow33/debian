#!/bin/bash

# Update the package index
#sudo apt update

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
