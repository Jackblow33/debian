#!/bin/bash

# extras.sh

USR=$(logname)

# PACKAGES TO INSTALL
INSTALL_PKGS=(
    'fastfetch'
    'gparted'
    'timeshift'
    'vlc'
)


# Function to handle errors
handle_error() {
    echo "Error occurred in the script. Exiting."
    sleep 2
    exit 1
}


update_upgrade() {
    # Update package list and upgrade installed packages
    echo "Updating package list and upgrading installed packages..."
    apt update && apt upgrade -y || { echo "Failed to update-upgrade"; handle_error; }
}

brave_browser() {
source /home/$USER/debian/brave.sh
}



install_pkg() {
    for PKG in "${INSTALL_PKGS[@]}"; do
        echo "INSTALLING: ${PKG}"
        apt install "$PKG" -y || { echo "Failed to install $PKG"; handle_error; }
    done
}


fastfetch_tweak() 
# Check if the .bashrc file exists
if [ -f "/home/$USER/.bashrc" ]; then
    # Check if the 'fastfetch' command is already in the .bashrc file
    if ! grep -q "fastfetch" "/home/$USER/.bashrc"; then
        # Add the 'fastfetch' command to the end of the .bashrc file
        echo "fastfetch" >> /home/$USER/.bashrc
        echo "fastfetch has been added to the .bashrc file."
    else
        echo "fastfetch is already in the .bashrc file."
    fi
else
    echo "The .bashrc file does not exist."
fi

}


# Function reboot countdown 10sec.
countdown_reboot() {
    local countdown_time=10

    # Function to handle Ctrl+C signal
    handle_sigint() {
        echo "Countdown interrupted. Exiting..."
        exit 0
    }

    # Trap the Ctrl+C signal and call the handle_sigint function
    trap handle_sigint SIGINT

    # Countdown loop
    for ((i=$countdown_time; i>0; i--)); do
        clear
        echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
        echo "                                                                                      Rebooting in $i seconds. Press Ctrl+C to cancel."
        sleep 1
    done

    # Reboot the system if Ctrl+C was not pressed
    echo "Rebooting system..."
    reboot
}


update_upgrade
brave_browser
install_pkg
fastfetch_tweak
countdown_reboot
