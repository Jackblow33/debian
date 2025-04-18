#!/bin/bash
#2025-04-17

# VARIABLES
TIMESTAMP=$(date +%Y%m%d.%R)
NV_VER="570.133.07"  # Nvidia Driver version
KERNEL="6.14.1-tkg-eevdf"
USR=$(logname) 
# Color
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

# Function to handle errors
handle_error() {
    echo "Error occurred in the script. Exiting."
    exit 1
}

# Root check
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

# Grant read, write, and execute permissions recursively to the root and user, and read permissions only to others.
sudo chmod -R 775 /home/$USR/debian

# Main menu
while true; do
    clear
    echo -e "\n\n\n\n\n\n\n\n\n\n"  # Clear the screen with new lines
    echo "                             Please select the options separated by a hyphen (-):"
    echo "                               1. Update System"
    echo "                               2. Install NVIDIA driver $NV_VER"
    echo "                               3. Install WiFi BCM4360"
    echo "                               4. Install custom kernel $KERNEL from USB"
    echo "                               5. Install Gnome"
    echo "                               6. Install Gnome extensions and customization"
    echo "                               7. Install Qemu-Kvm virtualization"
    echo "                               8. Exit"

    read -p "                             Enter your choice (e.g., 1-3-5): " choices

    IFS='-' read -ra selected_choices <<< "$choices"

    for choice in "${selected_choices[@]}"; do
        case $choice in
            1)
                echo "Updating system..."
                sudo apt update && sudo apt upgrade -y
                echo "System updated. Press [enter] to continue."
                read -r enterKey
                ;;
            2)
                echo "Installing NVIDIA driver $NV_VER..."
                source "/home/$USR/debian/hw-install/nvidia10.sh"
                ;;
            3)
                echo "Installing WiFi BCM4360..."
                source "/home/$USR/debian/hw-install/wifi-bcm43xx.sh"
                ;;
            4)
                echo "Installing custom kernel $KERNEL from USB..."
                source "/home/$USR/debian/kernel-install.sh"
                ;;
            5)
                echo "Installing Gnome..."
                source "/home/$USR/debian/gnome.sh"
                ;;
            6)
                echo "Installing Gnome..."
                source "/home/$USR/debian/gnome-extensions2.sh"
                ;;    
            7)
                echo "Installing qenu-kvm..."
                source "/home/$USR/debian/kvm-qemu-install.sh"    
                ;;
            8)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice. Please try again."
                sleep 2
                ;;
        esac
    done
done
