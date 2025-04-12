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


# Makes all script executable that are in the debian folder recursively
sudo find /home/$USR/debian -type f -name "*.sh" -exec chmod +x {} \;



# Function to display the menu
display_menu() {
    echo "Please select one or more options (separated by spaces):"
    echo "1. Install NVIDIA driver $NV_VER"
    echo "2. Install BCM4360"
    echo "3. Install custom kernel $KERNEL from USB "
    echo "4. Exit"
}

# Function to handle user input
handle_input() {
    read -p "Enter your choice(s) (1-4, separated by spaces): " choices

    # Convert the input to an array
    IFS=' ' read -ra selected_choices <<< "$choices"

    # Process the selected choices
    for choice in "${selected_choices[@]}"; do
        case $choice in
            1)
                echo "You selected Option 1"
                source /home/$USR/debian/nvidia.sh
                ;;
            2)
                echo "You selected Option 2"
                source /home/$USR/debian/hw-install/wifiinstall.sh
                ;;
            3)
                echo "You selected Option 3"
                source /home/$USR/debian/kernel-install.sh
                ;;
            4)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice: $choice. Please try again."
                ;;
        esac
    done
}

# Main loop
while true; do
    display_menu
    handle_input
done
