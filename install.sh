#!/bin/bash

# Execute as root

# EDIT THIS VARIABLE ######################################
USR=jack    ### Put your own user there instead of jack ###
###########################################################

#VARIABLES
TIMESTAMP=`date +%Y%m%d.%R`
NV_VER="570.133.07" # Nvidia Driver version

#VARIABLES
# Colors
GREEN='\033[0;32m'
NC='\033[0m' #no color

#fonctions
timer_start()
{
BEGIN=$(date +%s)
}

#fonctions
timer_stop()
{
    NOW=$(date +%s)
    let DIFF=$(($NOW - $BEGIN))
    let MINS=$(($DIFF / 60))
    let SECS=$(($DIFF % 60))
    echo Time elapsed: $MINS:`printf %02d $SECS`
}


sudo find /home/$USR/debian -type f -name "*.sh" -exec chmod +x {} \;

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
            source /home/$USR/debian/hw-install/nvidia.sh
            ;;
        2)
            source /home/$USR/debian/kernel-install.sh
            ;;
        3)
            source /home/$USR/debian/gnome.sh
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
