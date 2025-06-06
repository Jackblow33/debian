#!/bin/bash
#2025-04-20

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
    'firefox'
#    'gnome-shell-extension-prefs'
)

# PACKAGES TO UNINSTALL
UNINSTALL_PKGS=(
    'ifupdown'   # Mandatory all the next UNINSTALL_PKG entries are optional
    'gnome-tour'
    'gnome-calendar'
    'gnome-clocks'
    'yelp'
    'totem'
    'totem-plugins'
    'systemsettings'
    'gnome-weather'
    'gnome-contacts'
    'gnome-maps'
    'simple-scan'
    'firefox-esr'
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

# INSTALL FIREFOX NON-ESR - For debian Trixie
#echo "Installing Firefox browser..."
#apt install firefox || handle_error
#source /home/$USR/debian/firefox.sh || handle_error

# INSTALL BRAVE REPO AND INSTALL BRAVE WEB BROWSER
echo "Installing Brave browser..."
source /home/$USR/debian/brave.sh || handle_error
# sed -i 's|/usr/bin/brave-browser-stable|/usr/bin/brave-browser-stable --password-store=gnome|g' /usr/share/applications/brave-browser.desktop

# Install gnome extensions
source /home/$USR/debian/gnome-extensions.sh || handle_error

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

# Add function to right-click and create a new text file
# Does not work: create a template for new text file
#touch /home/$USR/Templates/Text.txt

# Stop the timer
timer_stop

# Notify user of completion
#echo -e "\n\n\nInstallation completed! Press Enter to reboot..."
#read -r

# Comment/Uncomment the following line to reboot or not
#shutdown -r now
