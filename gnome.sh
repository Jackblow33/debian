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

# Enable the Freon GNOME extension
echo "Enabling the Freon GNOME extension..."
if [ -f "/home/$USR/.config/dconf/user" ]; then
    dconf write /org/gnome/shell/enabled-extensions "['freon@UshakovVasilii_Github.yahoo.com']" || handle_error
    echo "Freon extension enabled in GNOME configuration."
else
    echo "GNOME configuration file not found. Please enable the Freon extension manually."
fi

# Disable hot corners
# Check if GNOME is running
if pgrep -x "gnome-shell" > /dev/null; then
    # Disable hot corners
    gsettings set org.gnome.desktop.interface enable-hot-corners false || handle_error
    echo "Hot corners disabled in GNOME."
else
    # Modify GNOME configuration file directly
    if [ -f "/home/$USR/.config/dconf/user" ]; then
        dconf write /org/gnome/desktop/interface/enable-hot-corners false || handle_error
        echo "Hot corners disabled in GNOME configuration file."
    else
        echo "GNOME is not running and the configuration file was not found."
    fi
fi



# Dash to Dock extension
EXTENSION_NAME="dash-to-dock@micxgx.gmail.com"
EXTENSION_DIR="/home/$USR/.local/share/gnome-shell/extensions/$EXTENSION_NAME"

# Check if the extension is already installed
if [ -d "$EXTENSION_DIR" ]; then
    echo "Dash to Dock extension is already installed."
else
    # Install Dash to Dock extension
    echo "Installing Dash to Dock extension..."
    mkdir -p "$EXTENSION_DIR" || handle_error
    git clone https://github.com/micheleg/dash-to-dock.git "$EXTENSION_DIR" || handle_error
    cd "$EXTENSION_DIR" || handle_error
    make || handle_error
    make install || handle_error
    echo "Dash to Dock extension installed."
fi

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
