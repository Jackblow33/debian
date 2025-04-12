#!/bin/bash

#NV_VER="570.133.07"
#KERNEL=6.14.1-tkg-eevdf
USR=jack        #put your own user there instead of jack

while true; do
    clear
    echo "Please select an option:"
    echo "1. Install NVIDIA $NV_VER"
    echo "2. Install kernel $KERNEL"
    echo "3. Install Gnome"
    echo "4. Install Gnome extension"
    echo "5. Install BCM_4360 wifi"
    echo "6. Exit"
    read -p "Enter your choice (1-5): " choice

    case $choice in
        1)
            source /home/$USR/debian/hw-install/nvidia.sh        #./nvidia.sh
            ;;
        2)
            source /home/$USR/debian/kernel.sh    #./kernel.sh
            ;;
        3)
            ./gnome.sh
            ;;
        4)
            ./gnome-extensions.sh
            ;;
        5)
            source /home/$USR/debian/hw-install/wifiinstall.sh       #./gkjhhjb.sh
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
