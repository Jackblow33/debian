#!/bin/bash
#2025-04-17

# Script to install GNOME and related packages on Debian
# References:
# https://wiki.debian.org/Gnome
# https://www.youtube.com/watch?v=zy-5UHC3t-Q

# PACKAGES TO INSTALL
INSTALL_PKGS=(
    'gnome-core'
    'kate'
    'make'
    'gettext'
    'sassc'
    'fastfetch'
    'gparted'
    'timeshift'
    'vlc'
    'lm-sensors'
)

# PACKAGES TO UNINSTALL
UNINSTALL_PKGS=(
    'ifupdown'
    'gnome-tour'
    'totem'
    'totem-plugins'
    'systemsettings'
    'gnome-weather'
    'gnome-contacts'
    'gnome-maps'
    'simple-scan'
    'firefox-esr'
    'cheese'
)

# Start the timer
timer_start

# Update package list and upgrade installed packages
echo "Updating package list and upgrading installed packages..."
sudo apt update && sudo apt upgrade -y

# INSTALL PACKAGES
for PKG in "${INSTALL_PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo apt install "$PKG" -y || { echo "Failed to install $PKG"; exit 1; }
done
# ADD BRAVE REPO AND INSTALL BRAVE WEB BROWSER
echo "Installing Brave browser..."
source /home/$USR/debian/brave.sh
# UNINSTALL PACKAGES
for PKG in "${UNINSTALL_PKGS[@]}"; do
    echo "UNINSTALLING: ${PKG}"
    sudo apt purge -y "$PKG" || { echo "Failed to uninstall $PKG"; exit 1; }
done
# REMOVE UNUSED DEPENDENCIES
sudo apt autoremove -y

# Edit NetworkManager configuration
echo "Configuring NetworkManager..."
sudo sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf

# Prepare lm-sensors
echo "Setting up lm-sensors..."
sensors-detect --auto

# Add function to right-click and create a new text file
# Does not work: create a template for new text file
# sudo touch /home/$USR/Templates/Text.txt

# Stop the timer
timer_stop

# Notify user of completion
echo -e "\n\n\nInstallation completed! Press Enter to reboot..."
read -r

# Uncomment the following line to reboot
sudo shutdown -r now
