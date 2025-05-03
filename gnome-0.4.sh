fau#!/bin/bash

# gnome-0.4.sh
# Date modified: 2025-05-03


update_upgrade() {
    # Update package list and upgrade installed packages
    echo "Updating package list and upgrading installed packages..."
    apt update && apt upgrade -y || handle_error
}

# default = gnome
install_desktop_environment() {
tasksel || handle_error
}


brave_browser() {
   echo "Installing Brave browser..."
   source /home/$USR/debian/brave.sh || handle_error
}



gnome_extensions() {
   source /home/$USR/debian/gnome-extensions.sh || handle_error
}

debloat() {
    source /home/$USR/debian/pkgs-tools/debloat.sh || handle_error
}

rm_unused_dep() {
    # REMOVE UNUSED DEPENDENCIES
    apt autoremove -y || handle_error
}


network_edit() {
    echo "Configuring NetworkManager..."
    sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf || handle_error
}


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



# Main script execution
root_check
timer_start
update_upgrade
install_desktop_environment
brave_browser
gnome_extensions
debloat
rm_unused_dep
# network_edit
# update_wireplumber_config
timer_stop


# apt list --installed
