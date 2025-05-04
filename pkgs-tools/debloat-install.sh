#!/bin/bash

# debloat-install.sh
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

apt install -y kate 
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
#sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf

# install brave web browser
source /home/jack/debian/brave.sh

# Tweak volume default = 40%(0.064) to default = 100%(1.0)
config_file="/usr/share/wireplumber/wireplumber.conf"
override_volume_tweak="/home/$USR/.config/wireplumber"

update_wireplumber_config() {
    # Check if the directory exists
    if [ ! -d "$override_volume_tweak" ]; then
        # Create directory if it does not exist
        mkdir -p "$override_volume_tweak" || { echo "Failed to create directory: $override_volume_tweak"; exit 1; }
        echo "Directory created: $override_volume_tweak"
    else
        echo "Directory already exists: $override_volume_tweak"
    fi

    # Copy the original file to the user's config directory
    cp "$config_file" "$override_volume_tweak/wireplumber.conf" || { echo "Failed to copy $config_file to $override_volume_tweak/wireplumber.conf"; exit 1; }

    # Replace the default value in the copied file
    sed -i 's/default = 0.064/default = 1.0/g' "$override_volume_tweak/wireplumber.conf" || { echo "Failed to update $override_volume_tweak/wireplumber.conf"; exit 1; }

    echo "The wireplumber.conf file has been updated in $override_volume_tweak."
}

# update_wireplumber_config


echo "Uninstallation + installation completed. Rebooting."
sleep 10
reboot
