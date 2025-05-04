#!/bin/bash

# pkgs-tools.sh
# 2025-05-04

USR=$(logname)
dir_tools="/home/$USR/Downloads/pkgs-tools"
sudo mkdir $dir_tools
while true; do
    clear
    echo -e "\n\n\n\n\n\n\n\n\n\n"  # Clear the screen with new lines
    echo "                             Please select an option:"
    echo "                               1. Build packages list from base installation"
    echo "                               2. Debloat full installation before building the list"
    echo "                               3. Build packages list from full debloated installation"
    echo "                               4. Build final packages diffs full - base"
    echo "                               5. Exit"

    read -p "                             Enter your choice: " choice

    case $choice in
        1)
            echo "Building packages list from base installation"
            source $dir_tools/base-pkgs-list.sh
            ;;
        2)
            echo "Debloating full installation"
            source $dir_tools/debloat.sh
            ;;
        3)
            echo "Building packages list from full debloated installation"
            source $dir_tools/full-pkgs-list.sh
            ;;
        4)
            echo "Building final packages diffs full/base"
            source $dir_tools/diff-pkgs-list.sh
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

