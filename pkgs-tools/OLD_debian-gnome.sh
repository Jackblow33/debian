#!/bin/bash

# Debian sid base gnome desktop environment packages installer (Linux from scratch).

# Set the input file path
USR=$(logname)
input_file="/home/$USR/debian/pkgs-tools/pkgs.list"
start_time=$SECONDS

if ! whiptail --title "Debian 13 sid Installation" --yesno "You are about to install Debian 13 sid packages. Would you like to proceed?" 8 60; then
    echo "Installation cancelled."
    exit 1
fi

# Install the packages
sudo apt-get install -y $(cat "$input_file")

end_time=$SECONDS
elapsed_time=$((end_time - start_time))
elapsed_minutes=$((elapsed_time / 60))
elapsed_seconds=$((elapsed_time % 60))

total_time_message="Total time elapsed: $elapsed_minutes minutes and $elapsed_seconds seconds."
reboot_message="The packages have been installed successfully. A reboot is required to complete the installation. Press Enter to reboot the system."

whiptail --title "Installation Complete" --msgbox "$total_time_message\n\n$reboot_message" 12 60

read -p "" 

sudo reboot

