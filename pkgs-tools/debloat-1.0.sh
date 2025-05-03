#!/bin/bash

# rm-pkgs-debian-full-install.sh
# Remove packages from a Debian default gnome installation.

# Set the total number of packages to uninstall
TOTAL_STEPS=${#packages[@]}

# Initialize the current step
CURRENT_STEP=0

# List of packages to uninstall
packages=(
    gnome-calendar
    gnome-clocks
    gnome-contacts
    gnome-keyring
    gnome-keyring-pkcs11
    gnome-maps
    gnome-music
    gnome-sound-recorder
    gnome-tour
    gnome-tweaks
    gnome-user-docs
    gnome-weather
    gnome
#    ifupdown
    libreoffice-*
    simple-scan
    systemsettings
    totem
    totem-plugins
    yelp
)

# Uninstall each package
for pkg in "${packages[@]}"; do
    # Update the current step
    CURRENT_STEP=$((CURRENT_STEP + 1))

    # Calculate the percentage
    PERCENTAGE=$((CURRENT_STEP * 100 / TOTAL_STEPS))

    # Display the progress bar
    whiptail --gauge "Removing $pkg..." 8 78 $PERCENTAGE

    # Uninstall the package
    sudo apt-get purge -y "$pkg"

    # Simulate some work
    sleep 1
done

# Clean up any unused dependencies
echo "Cleaning up unused dependencies..."
sudo apt-get autoremove -y

# Optionally, clean up package cache
echo "Cleaning up package cache..."
sudo apt-get clean -y

# Configuring NetworkManager
sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf

# Display a success message
whiptail --msgbox "Uninstallation complete." 8 78
