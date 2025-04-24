#!/bin/bash

# tkg-kernel-build.sh

# As user
# If you have it. Put your custom-customization.cfg and/or custom-modprobed.db into /home/$USER/linux-tkg folder


PATH="/$HOME/linux-tkg/"

while true; do
    clear
    echo "What would you like to do?"
    echo "1. Git Frogging-Family/linux-tkg"
    echo "2. Edit the \"customization.cfg\" file?"
    echo "3. Use \"custom-customization.cfg\""
    echo "4. Use minimal-modprobed.db"
    echo "5. Use custom-modprobed.db"
    echo "6. Start TKG-kernel compilation"
    echo "7. Exit"

    read -p "Enter your choice (1-7): " choice

    case $choice in

        1)
            echo 'Git linux-tkg'
            sudo apt install git
            cd /$HOME
            git clone https://github.com/Frogging-Family/linux-tkg.git
            read -p "Press Enter to continue" _
            ;;

        2)
            echo -e "\e[33medit the \"customization.cfg\" file?\e[0m"
            sudo nano $PATH/customization.cfg
            ;;
        3)
            echo "Use \"custom-customization.cfg\""
            if [ -f "$PATH/custom-customization.cfg" ]; then
                if [ -f "$PATH/customization.cfg" ]; then
                    read -p "This will overwrite the existing customization.cfg file. Do you want to continue? (y/n) " confirm
                    if [ "$confirm" = "y" ]; then
                        sudo cp $PATH/custom-customization.cfg $PATH/customization.cfg
                    else
                        echo "Operation cancelled."
                        read -p "Press Enter to continue" _
                    fi
                else
                    sudo cp $PATH/custom-customization.cfg $PATH/customization.cfg
                fi
            else
                echo "custom-customization.cfg not found in $PATH"
                read -p "Press Enter to continue" _
            fi
            ;;

        4)
            echo "Using minimal-modprobed.db"
            if [ -f "$PATH/minimal-modprobed.db" ]; then
                if [ -f "$HOME/.config/modprobed.db" ]; then
                    read -p "This will overwrite the existing modprobed.db file. Do you want to continue? (y/n) " confirm
                    if [ "$confirm" = "y" ]; then
                        sudo cp $PATH/minimal-modprobed.db $HOME/.config/modprobed.db
                    else
                        echo "Operation cancelled."
                        read -p "Press Enter to continue" _
                    fi
                else
                    sudo cp $PATH/minimal-modprobed.db $HOME/.config/modprobed.db
                fi
            else
                echo "minimal-modprobed.db not found in $PATH"
                read -p "Press Enter to continue" _
            fi
            ;;

        5)
            echo "Using custom-modprobed.db"
            if [ -f "$PATH/custom-modprobed.db" ]; then
                if [ -f "$HOME/.
