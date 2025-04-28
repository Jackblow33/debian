
#!/bin/bash

#install-2.6.sh
#2025-04-27

# VARIABLES
USR=$(logname)
SH_PATH="/home/$USR/debian/testing"
TIMESTAMP=$(date +%Y%m%d.%R)
NV_VER="570.133.07"  # Default Nvidia Driver version
KERNEL="6.14.3-tkg-bore"
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'  # No color

# Functions
timer_start() {
    BEGIN=$(date +%s)
}

# Functions
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
    sleep 2
    exit 1
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
        echo "Rebooting in $i seconds. Press Ctrl+C to cancel."
        sleep 1
    done

    # Reboot the system if Ctrl+C was not pressed
    echo "Rebooting system..."
    reboot
}

# Root check
root_check() {
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi
}

root_check

# Grant read, write, and execute permissions recursively to the root and user, and read permissions only to others.
sudo chmod -R 77 /home/$USR/debian

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
    echo "                               6. Install Qemu-Kvm virtualization"
    echo "                               7. Reboot system"
    echo "                               8. Exit"

    read -p "                             Enter your choice (e.g., 1-2-5): " choices

    IFS='-' read -ra selected_choices <<< "$choices"

    for choice in "${selected_choices[@]}"; do
        case $choice in
            1)
                echo "Updating system..."
                apt modernize-sources -y && apt update && apt upgrade -y
                ;;
            2)
                echo "Installing NVIDIA driver $NV_VER..."
                source "$SH_PATH/nvidia-11.4.sh"
                ;;
            3)
                echo "Installing WiFi BCM4360..."
                source "$SH_PATH/wifi-bcm43xx-0.1.sh"
                ;;
            4)
                echo "Installing custom kernel $KERNEL from USB..."
                source "$SH_PATH/kernel-install.sh"
                ;;
            5)
                echo "Installing Gnome..."
                source "$SH_PATH/gnome-0.1.sh"
                ;;
           
            6)
                echo "Installing qenu-kvm..."
                source "$SH_PATH/qemu-kvm-0.6.sh"
                ;;

            7)
                echo "Reboot system..."
                countdown_reboot
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
