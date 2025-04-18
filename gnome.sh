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
apt update && apt upgrade -y || handle_error

# INSTALL PACKAGES
for PKG in "${INSTALL_PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    apt install "$PKG" -y || { echo "Failed to install $PKG"; handle_error; }
done

# ADD BRAVE REPO AND INSTALL BRAVE WEB BROWSER
echo "Installing Brave browser..."
source /home/$USR/debian/brave.sh || handle_error
sed -i 's|/usr/bin/brave-browser-stable|/usr/bin/brave-browser-stable --password-store=gnome|g' /usr/share/applications/brave-browser.desktop

# UNINSTALL PACKAGES
for PKG in "${UNINSTALL_PKGS[@]}"; do
    echo "UNINSTALLING: ${PKG}"
    apt purge -y "$PKG" || { echo "Failed to uninstall $PKG"; handle_error; }
done

# REMOVE UNUSED DEPENDENCIES
apt autoremove -y || handle_error

# Edit NetworkManager configuration
echo "Configuring NetworkManager..."
sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf || handle_error

# Prepare lm-sensors to generate values for freon extension
echo "Setting up lm-sensors..."
sensors-detect --auto || handle_error
#freon gnome-shell-extension-sensors install
apt install  gnome-shell-extension-freon || handle_error

# Add function to right-click and create a new text file
# Does not work: create a template for new text file
touch /home/$USR/Templates/Text.txt

# Stop the timer
timer_stop

# Notify user of completion
echo -e "\n\n\nInstallation completed! Press Enter to reboot..."
read -r

# Comment/Uncomment the following line to reboot or not
shutdown -r now
