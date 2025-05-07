#!/bin/bash

# Debian sid base gnome desktop environment packages installer over a base minimal installation.

USR=$(logname)
LOG_DIR="/home/$USR/debian/LOGS"
LOG_FILE="install.log"
mkdir $LOG_DIR
input_file="/home/$USR/debian/pkgs-tools/tasksel_pkgs.list"

start_time=$SECONDS

welcome() {
if ! whiptail --title "Debian 13 sid Installation" --yesno "You are about to install Debian 13 sid packages. Would you like to proceed?" 8 60; then
    echo "Installation cancelled."
    exit 1
fi
}

update_upgrade() {
    # Update package list and upgrade installed packages
    echo "Updating package list and upgrading installed packages..."
    apt update && apt upgrade -y || handle_error
}


install_packages() {
sudo apt-get install -y $(cat "$input_file")
}


brave_browser() {
   echo "Installing Brave browser..."
   source /home/$USR/debian/brave.sh || handle_error
}


gnome_extensions() {
   source /home/$USR/debian/gnome-extensions.sh || handle_error
}


rm_package() {
     apt purge -y ifupdown yelp
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



ending() {
end_time=$SECONDS
elapsed_time=$((end_time - start_time))
elapsed_minutes=$((elapsed_time / 60))
elapsed_seconds=$((elapsed_time % 60))

total_time_message="Gnone install, total time elapsed: $elapsed_minutes minutes and $elapsed_seconds seconds."
echo "$total_time_message" >> "$LOG_DIR/$LOG_FILE"

echo "$total_time_message"
}


# Main script execution
welcome
update_upgrade
install_packages
#brave_browser
#gnome_extensions
rm_package
#rm_unused_dep
network_edit
update_wireplumber_config
ending



