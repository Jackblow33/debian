#!/bin/bash

# debloat.sh
# Remove packages from a Debian sid default gnome installation.

USR=$(logname)
log_file="/home/$USR/debian/LOGS/installation-$timestamp.log"

root_check() {
if [ "$EUID" -ne 0 ]; then
  echo "This script must be executed as root!! Exiting......."
  exit 1
fi
}

# List of packages to uninstall
packages=(
    gnome-calendar
    gnome-clocks
    gnome-contacts
    gnome-keyring
    gnome-keyring-pkcs11
    gnome-maps
    gnome-music
    gnome-snapshot
    gnome-sound-recorder
    gnome-tour
    gnome-tweaks
    gnome-user-docs
    gnome-weather
    gnome
#    ifupdown
    libreoffice-*
    malcontent
    shotwell
    simple-scan
    systemsettings
    totem
    totem-plugins
    yelp
)

root_check
mkdir $log_file

# Uninstall packages
for pkg in "${packages[@]}"; do
    echo "Removing $pkg..."
    sudo apt-get purge -y "$pkg" 2>&1 | tee -a "$log_file"
done

# Clean up any unused dependencies
echo "Cleaning up unused dependencies..."
sudo apt-get autoremove -y

# Optionally, clean up package cache
echo "Cleaning up package cache..."
sudo apt-get clean -y

# install brave web browser
#source /home/$USR/debian/brave.sh
