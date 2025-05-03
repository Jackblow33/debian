#!/bin/bash

# Add functions & variables

USR=$(logname)
sudo mkdir /home/$USR/debian/pkgs-tools

# Main menu
while true; do
    clear
    echo -e "\n\n\n\n\n\n\n\n\n\n"  # Clear the screen with new lines
    echo "                             Please select the options separated by a hyphen (-):"
    echo "                               1. Build packages list from base installation"
    echo "                               2. Build packages list from full installation"
    echo "                               3. Build final packages diffs full/base"
    echo "                               4. Exit"

    read -p "                             Enter your choice (e.g., 1-2-4): " choices

    IFS='-' read -ra selected_choices <<< "$choices"

    for choice in "${selected_choices[@]}"; do
        case $choice in
            1)
                echo "Building packages list from base installation"
                source /home/$USR/debian/pkgs-tools/base-pkgs-list.sh
                ;;
            2)
                echo "Building packages list from full installation"
                source /home/$USR/debian/pkgs-tools/full-pkgs-list.sh
                ;;
            3)
                echo "Building final packages diffs full/base"
                source /home/$USR/debian/pkgs-tools/diff-pkgs-list.sh
                ;;

            4)
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
