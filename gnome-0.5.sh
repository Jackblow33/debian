#!/bin/bash

# gnome-0.5.sh

USR=$(logname)

root_check() {
if [ "$EUID" -ne 0 ]; then
  echo "This script must be executed as root!! Exiting......."
  exit 1
fi
}
root_check

# Gnome installation
install_desktop_environment() {
tasksel install desktop gnome-desktop  || handle_error
}
install_desktop_environment

sudo apt install -y kate 

# Configuring NetworkManager
#sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf

# install brave web browser
#source /home/$USR/debian/brave.sh
# Install freon & dash to dock - gnome extensions
source /home/$USR/debian/gnome-extensions.sh


# Tweak volume default = 40%(0.064) to default = 100%(1.0)
update_wireplumber_config() {
    local config_file="/usr/share/wireplumber/wireplumber.conf"
    local override_volume_tweak="/home/$USR/.config/wireplumber"
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

update_wireplumber_config


echo "Uninstallation + installation completed."         #Rebooting in 10 seconds ..."
#sleep 10
#reboot
