#!/bin/bash

# Add functions & variables


# Main menu
while true; do
    clear
    echo -e "\n\n\n\n\n\n\n\n\n\n"  # Clear the screen with new lines
    echo "                             Please select the options separated by a hyphen (-):"
    echo "                               1. Action 1"
    echo "                               2. Action 2"
    echo "                               3. Action 3"
    echo "                               4. Action 4"
    echo "                               5. Action 5"
    echo "                               6. Action 6"
    echo "                               7. Reboot system"
    echo "                               8. Exit"

    read -p "                             Enter your choice (e.g., 1-2-5): " choices

    IFS='-' read -ra selected_choices <<< "$choices"

    for choice in "${selected_choices[@]}"; do
        case $choice in
            1)
                echo "Action 1"
                ;;
            2)
                echo "Action 2"
                source "/path/to/script/action-2.sh"
                ;;
            3)
                echo "Action 3"
                ;;
            4)
                echo "Action 4"
                source "/home/$USR/debian/kernel-install.sh"
                ;;
            5)
                echo "Action 5"
                ;;

            6)
                echo "Action 6"
                ;;

            7)
                echo "Reboot system..."
                shutdown -r now
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
