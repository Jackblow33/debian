
#!/bin/bash
#2025-04-26

USR="logname"

# Grab variables and functions from:  /home/$USR/debian/VARIABLES_functions.sh
source /home/$USR/debian/VARIABLES_functions.sh

root_check

# Grant read, write, and execute permissions recursively to the root and user, and read permissions only to others.
sudo chmod -R 777 /home/$USR/debian

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
                apt update && apt upgrade -y
                ;;
            2)
                echo "Installing NVIDIA driver $NV_VER..."
                source "/home/$USR/debian/hw-install/nvidia-11.4.sh"
                ;;
            3)
                echo "Installing WiFi BCM4360..."
                source "/home/$USR/debian/hw-install/wifi-bcm43xx-0.1.sh"
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
                echo "Installing qenu-kvm..."
                source "/home/$USR/debian/qemu-kvm-0.6.sh"    
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
