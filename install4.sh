#!/bin/bash

# Execute as root

# EDIT THIS VARIABLE ######################################
USR=jack    ### Put your own user there instead of jack ###
###########################################################

#VARIABLES
source /home/$USR/debian/VARIABLES.sh
#fonctions
source /home/$USR/debian/fonctions.sh


# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi


# Makes all script executable that are in the debian folder recursively
sudo find /home/$USR/debian -type f -name "*.sh" -exec chmod +x {} \;

while true; do
    clear
    echo ''
    echo ''
    echo ''
    echo "Please select an option:"
    echo "1. Install NVIDIA driver $NV_VER"
    echo "2. Install Install wifi BCM4360"
    echo "3. Install custom kernel $KERNEL from USB"
    echo "4. Install Gnome"
    echo "5. Install Gnome-extensions and customize"
    echo "6. Exit"
    read -p "Enter your choice (1-5): " choice

    case $choice in
        1)
            source /home/$USR/debian/hw-install/nvidia.sh
            ;;
        2)
            source /home/$USR/debian/hw-install/wifiinstall.sh
            ;;
        3)
            source /home/$USR/debian/kernel-install.sh
            ;;
        4)
            source /home/$USR/debian/gnome.sh
            ;;
        5)
            source /home/$USR/debian/gnome-extensions.sh
            ;;    
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            sleep 2
            ;;
    esac
done
