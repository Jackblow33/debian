#!/bin/bash

# rm-pkgs-debian-full-install.sh
# Remove packages from a Debian default gnome installation and install some.


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

# Uninstall each package
for pkg in "${packages[@]}"; do
    echo "Removing $pkg..."
    sudo apt-get purge -y "$pkg"
done

# Clean up any unused dependencies
echo "Cleaning up unused dependencies..."
sudo apt-get autoremove -y

# Optionally, clean up package cache
echo "Cleaning up package cache..."
sudo apt-get clean -y

# Configuring NetworkManager
sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf

echo "Uninstallation complete."
