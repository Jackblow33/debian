#!/bin/bash


echo''
echo''
echo''
# Function to display the menu
display_menu() {
    echo "Please select option(s) (comma-separated):"
    echo "1) Install kernel from USB"
    echo "2) Install NVIDIA driver"
    echo "3) Install wifi BCM4360"
    echo "4) Install Gnome slim install"
    echo "5) Exit"
}

# Main loop
while true; do
    display_menu
    read -p "Enter your choices (1,2,3) or 'exit' to finish: " input

    if [[ "$input" == "exit" ]]; then
        echo "Exiting the menu."
        break
    fi

    # Convert the input into an array
    IFS=',' read -r -a choices <<< "$input"

    # Process each choice
    for choice in "${choices[@]}"; do
        choice=$(echo "$choice" | xargs)  # Trim whitespace
        case "$choice" in
            1)
                echo "Kernel installation start"
                source /home/jack/debian/kernel-install.sh
                ;;
            2)
                echo "NVIDIA Proprietary driver install"
                source /home/jack/debian/hw-install/nvidia.sh
                ;;
            3)
                echo "Install wifi BCM4360"
                source /home/jack/debian/hw-install/wifiinstall.sh
                ;;
            4)
                echo "Gnome slim install"
                source /home/jack/debian/gnome.sh
                ;;
            *)
                echo "Invalid choice: $choice. Please select options between 1 and 5."
                ;;
        esac
    done
done

