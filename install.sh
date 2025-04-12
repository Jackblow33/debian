#!/bin/bash

# Execute as root

# EDIT THIS VARIABLE ######################################
USR=jack    ### Put your own user there instead of jack ###
###########################################################


while true; do
    clear
    echo "Please select an option:"
    echo "1. Install NVIDIA driver $NV_VER"
    echo "2. Install kernel $KERNEL from USB"
    echo "3. Install Gnome"
    echo "4. Install Gnome extensions"
    echo "5. Exit"
    read -p "Enter your choice (1-5): " choice

    case $choice in
        1)
            source /home/$USR/debian/hw-install/nvidia.sh   #./script1.sh
            ;;
        2)
            source /home/$USR/debian/kernel.sh              #./script2.sh
            ;;
        3)
            ./gnome.sh
            ;;
        4)
            ./gnome-extensions.sh
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            sleep 2
            ;;
    esac
done
