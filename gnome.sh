#!/bin/bash
#2025-04-14

# Script to install GNOME and related packages on Debian
# References:
# https://wiki.debian.org/Gnome
# https://www.youtube.com/watch?v=zy-5UHC3t-Q

# VARIABLES
PKGS=(
    'gnome-core'                # Core components of the GNOME Desktop environment
    'kate'                      # KDE advanced text editor
    'make'                      # General purpose dependency solver
    'gettext'                   # Build dependencies for dash-to-dock
    'sassc'                     # Build dependencies for dash-to-dock
    'fastfetch'                 # Fetching system information in terminal
    'gparted'                   # Partition utility
    'timeshift'                 # Program for system backups/snapshots
    'vlc'                       # Free software to play, transcode, and broadcast video and audio files
    'lm-sensors'                # Hardware health monitoring
)


# Start the timer
timer_start

# Update package list and upgrade installed packages
echo "Updating package list and upgrading installed packages..."
sudo apt update && sudo apt upgrade -y

# Install packages
for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo apt install "$PKG" -y || { echo "Failed to install $PKG"; exit 1; }
done

# Install Brave browser
echo "Installing Brave browser..."
source /home/$USR/debian/brave.sh

# Remove unnecessary applications
echo "Removing unnecessary applications..."
sudo apt purge ifupdown gnome-tour totem totem-plugins systemsettings -y
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
