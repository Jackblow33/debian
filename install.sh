#!/bin/bash

# Execute as root

# EDIT THIS VARIABLE ######################################
USR=jack    ### Put your own user there instead of jack ###
###########################################################

#VARIABLES
TIMESTAMP=`date +%Y%m%d.%R`
NV_VER="570.133.07" # Nvidia Driver version
KERNEL=6.14.1-tkg-eevdf

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


# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Check if the user is not root
#if [ "$EUID" -eq 0 ]; then
#    echo "This script should not be run as the root user."
#    exit 1
#fi

# Rest of the script goes here
echo "Script is running as a non-root user."

# Makes all script executable that are in the debian folder recursively
sudo find /home/$USR/debian -type f -name "*.sh" -exec chmod +x {} \;

while true; do
    clear
    echo '' ; echo '' ; echo '' ; echo '' ; echo '' ; echo '' ; echo '' ; echo '' ; echo '' ; echo ''
    echo '' ; echo '' ; echo '' ; echo '' ; echo '' ; echo '' ; echo '' ; echo '' ; echo '' ; echo ''
    echo "                             Please select an option:"
    echo "                               1. Update System"
    echo "                               2. Install NVIDIA driver $NV_VER"
    echo "                               3. Install Install wifi BCM4360"
    echo "                               4. Install custom kernel $KERNEL from USB"
    echo "                               5. Install Gnome"
    echo "                               6. Exit"
    read -p "                             Enter your choice (1-6): " choice
    
    case $choice in
        
        1)
            sudo apt update && sudo apt upgrade
            echo "Press [enter] to continue "; read enterKey
            ;;
        2)
            source /home/$USR/debian/hw-install/nvidia-ai.sh
            ;;
        3)
            source /home/$USR/debian/hw-install/wifiinstall.sh
            ;;
        4)
            source /home/$USR/debian/kernel-install.sh
            ;;
        5)
            source /home/$USR/debian/gnome.sh
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
