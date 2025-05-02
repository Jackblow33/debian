#!/bin/bash

# gnome-0.1.sh
# Date modified: 2025-04-27


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
)

# PACKAGES TO UNINSTALL
UNINSTALL_PKGS=(
    'ifupdown'   # Mandatory all the next UNINSTALL_PKG entries are optional
    'gnome-tour'
    'gnome-calendar'
    'gnome-clocks'
    'gnome-keyring'
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




update_upgrade() {
    # Update package list and upgrade installed packages
    echo "Updating package list and upgrading installed packages..."
    apt update && apt upgrade -y || handle_error
}



install_pkg() {
    for PKG in "${INSTALL_PKGS[@]}"; do
        echo "INSTALLING: ${PKG}"
        apt install "$PKG" -y || { echo "Failed to install $PKG"; handle_error; }
    done
}



brave_browser() {
   echo "Installing Brave browser..."
   source /home/$USR/debian/brave.sh || handle_error
}



gnome_extensions() {
   source /home/$USR/debian/gnome-extensions.sh || handle_error
}



uninstall_pkg() {
   for PKG in "${UNINSTALL_PKGS[@]}"; do
        echo "UNINSTALLING: ${PKG}"
        apt purge -y "$PKG" || { echo "Failed to uninstall $PKG"; handle_error; }
    done
}



rm_unused_dep() {
    # REMOVE UNUSED DEPENDENCIES
    apt autoremove -y || handle_error
}



network_edit() {
    echo "Configuring NetworkManager..."
    sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf || handle_error
}


update_wireplumber_config() {
    # Get the current user's home directory
    home_dir="/home/$USR"
    file_path="/home/$USR/.config/wireplumber/wireplumber.conf"
    config_file="$home_dir/.config/wireplumber/wireplumber.conf"

    # Check if the file exists
    if [ -f "$config_file" ]; then
        # Backup the original file
        backup_file="$config_file.bak"
        cp "$config_file" "$backup_file"

        # Replace the default value
        sed -i 's/default = 0.064/default = 1.0/g' "$config_file"

        echo "The wireplumber.conf file has been updated."
        echo "A backup of the original file has been created at $backup_file."
    else
        echo "The wireplumber.conf file does not exist in $home_dir/.config/wireplumber/"
    fi
}



# Main script execution
root_check
timer_start
update_upgrade
install_pkg
brave_browser
gnome_extensions
uninstall_pkg
rm_unused_dep
network_edit
update_wireplumber_config
timer_stop
