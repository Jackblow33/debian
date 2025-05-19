#!/bin/bash

# gnome-0.4.1sh
# Date modified: 2025-05-11

# Check if the installation was successful
check() {
if [ $? -ne 0 ]; then
    echo "Command fail. Press Enter to continue."
    read -s
fi
}

update_upgrade() {
    # Update package list and upgrade installed packages
    echo "Updating package list and upgrading installed packages..."
    sudo apt update && sudo apt upgrade -y || handle_error
}

# Minimal Gnome packages installation & settings
install_desktop_environment() {
input_file="/home/$USR/debian/pkgs-tools/tasksel_pkgs.list"
sudo apt-get install -y $(cat "$input_file") || handle_error

sudo mkdir -p /home/$USR/.local/state/wireplumber || check
sudo chown -R $USR:$USR /home/$USR/.local/state/wireplumber || check
#sudo chown -R $USR:$USR /home/$USR/.local || check
#gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg
source /home/$USR/debian/gnome-keyring-setup.sh
}


kate() {
   echo "Installing Kate text editor..."
   apt install -y kate || handle_error
   apt purge -y systemsettings
}


brave_browser() {
   echo "Installing Brave browser..."
   source /home/$USR/debian/brave.sh || handle_error
}



gnome_extensions() {
   source /home/$USR/debian/gnome-extensions.sh || handle_error
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
gnome_extensions
#brave_browser                       # move this to post installation with: libavcodec-extra vlc
kate
network_edit
#update_wireplumber_config    !!! HAVE to be put after first boot
rm_unused_dep
timer_stop


# apt list --installed
