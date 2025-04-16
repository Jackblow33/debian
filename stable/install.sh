#!/bin/bash
#2025-04-14

# Execute as root

# EDIT THIS VARIABLE ######################################
USR="jack"    # Put your own user there instead of jack
###########################################################

# VARIABLES
TIMESTAMP=$(date +%Y%m%d.%R)
NV_VER="570.133.07"  # Nvidia Driver version
KERNEL="6.14.1-tkg-eevdf"

# Colors
GREEN='\033[0;32m'
NC='\033[0m'  # No color

# Functions
timer_start() {
    BEGIN=$(date +%s)
}

timer_stop() {
    NOW=$(date +%s)
    DIFF=$((NOW - BEGIN))
    MINS=$((DIFF / 60))
    SECS=$((DIFF % 60))
    echo "Time elapsed: $MINS:$(printf %02d $SECS)"
}

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Make all scripts in the debian folder executable recursively
find "/home/$USR/debian" -type f -name "*.sh" -exec chmod +x {} \;

# Main menu loop
while true; do
    clear
    echo -e "\n\n\n\n\n\n\n\n\n\n"  # Clear the screen with new lines
    echo "                             Please select an option:"
    echo "                               1. Update System"
    echo "                               2. Install NVIDIA driver $NV_VER"
    echo "                               3. Install WiFi BCM4360"
    echo "                               4. Install custom kernel $KERNEL from USB"
    echo "                               5. Install Gnome"
    echo "                               6. Exit"

    read -p "                             Enter your choice (1-6): " choice

    case $choice in
        1)
            echo "Updating system..."
            sudo apt update && sudo apt upgrade -y
            echo "System updated. Press [enter] to continue."
            read -r enterKey
            ;;
        2)
            echo "Installing NVIDIA driver $NV_VER..."
            source "/home/$USR/debian/stable/nvidia.sh"
            ;;
        3)
            echo "Installing WiFi BCM4360..."
            source "/home/$USR/debian/stable/wifi-bcm43xx.sh"
            ;;
        4)
            echo "Installing custom kernel $KERNEL from USB..."
            source "/home/$USR/debian/stable/kernel-install.sh"
            ;;
        5)
            echo "Installing Gnome..."
            source "/home/$USR/debian/stable/gnome.sh"
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
