#!/bin/bash
#2025-04-30

# VARIABLES
USR=$(logname)
SH_PATH="/home/$USR/debian"
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
  echo "This script must be executed as root!! Exiting......."
  exit 1
fi
}


# User check. If root, script will exit
user_check() {
if [[ $EUID -eq 0 ]]; then
    echo "This script should be executed as root!! Exiting......."
    exit 1
fi
}


# Function to display the menu
display_menu() {
    local menu_options=(
        "Update system"
        "Install NVIDIA driver $NV_VER"
        "Install WiFi BCM4360"
        "Install custom kernel $KERNEL from USB"
        "Install Gnome"
        "Install Qemu-Kvm virtualization"
        "Reboot system"
        "Exit"
    )



###############################################################################################################


# Grant read, write, and execute permissions recursively to the root, user and others. Use at your own risk!!!
chmod -R 777 $SH_PATH

    local choice
    choice=$(whiptail --title "System Configuration Menu" --menu "Choose an option:" 20 78 12 "${menu_options[@]}" 3>&1 1>&2 2>&3)

    case $choice in
        "Update system")
            echo "Updating system..."
            apt update && apt upgrade -y
            ;;
        "Install NVIDIA driver $NV_VER")
            echo "Installing NVIDIA driver $NV_VER..."
            source "$SH_PATH/hw-install/nvidia-11.4.sh"
            ;;
        "Install WiFi BCM4360")
            echo "Installing WiFi BCM4360..."
            source "$SH_PATH/hw-install/wifi-bcm43xx-0.1.sh"
            ;;
        "Install custom kernel $KERNEL from USB")
            echo "Installing custom kernel $KERNEL from USB..."
            source "$SH_PATH/kernel-install.sh"
            ;;
        "Install Gnome")
            echo "Installing Gnome..."
            source "$SH_PATH/gnome-0.1.sh"
            ;;
        "Install Qemu-Kvm virtualization")
            echo "Installing qemu-kvm..."
            source "$SH_PATH/qemu-kvm-0.6.sh"
            ;;
        "Reboot system")
            echo "Rebooting system..."
            countdown_reboot
            ;;
        "Exit")
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
}

# Function to display a countdown and reboot the system
#countdown_reboot() {
#    local countdown=10
#    while [ $countdown -gt 0 ]; do
#        echo "Rebooting in $countdown seconds..."
#        countdown=$((countdown - 1))
#        sleep 1
#    done
#    reboot
#}

# Call the display_menu function
root_check
display_menu
