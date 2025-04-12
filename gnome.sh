#!/bin/bash

#https://wiki.debian.org/Gnome  &&  https://www.youtube.com/watch?v=zy-5UHC3t-Q


#VARIABLE
PKGS=(
        'gnome-core'                #  Core components of the GNOME Desktop environment
#        'gedit'                     # Text editor
        'kate'                      # Kde advanced test editor
        'make'                      # general purpose dependency solver
        'gettext'                   # build depends for dash-to-dock
        'sassc'                     # build depends for dash-to-dock
        'fastfetch'                 # Fetching system information in terminal
        'gparted'                   # Partition utility
        'timeshift'                 # Timeshift is a program used to make system back-ups/snapshots easily
        'vlc'                       # VLC is free software to play, transcode and broadcast video and audio files
        'lm-sensors'                # Hardware health monitoring
)

#fonctions
#timer_start()
#{
#BEGIN=$(date +%s)
#}

#fonctions
#timer_stop()
#{
#    NOW=$(date +%s)
#    let DIFF=$(($NOW - $BEGIN))
#    let MINS=$(($DIFF / 60))
#    let SECS=$(($DIFF % 60))
#    echo Time elapsed: $MINS:`printf %02d $SECS`
#}


timer_start
#sudo apt update && sudo apt upgrade

#Packages installer
for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo apt install "$PKG" -y #|| sudo pacman -S "$PKG" --noconfirm --needed
done
# Install brave # Privacy oriented web browser
source /home/$USR/debian/brave.sh


#remove apps
sudo apt purge ifupdown gnome-tour totem totem-plugins systemsettings -y && sudo apt autoremove systemsettings -y   #gnome-text-editor

sudo sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf  #Editing NetworkManager file: managed=false to managed=true
#Check system|network|IPv4 and make sure static ip address or dhcp is set properly

 #fastfetch auto load in terminal
    #Make a copy of .bashrc before edit
    cp sudo /home/$USR/.bashrc /home/$USR/.bashrc.$TIMESTAMP
    echo "fastfetch" >> ~/.bashrc

# Getting lm-sensor ready
sensors-detect --auto

# Add fonction to right-click and create new text file
    sudo touch /home/$USR/Templates/Text.txt

timer_stop
echo "Press [enter] "; read enterKey
#sudo shutdown -r now      #reboot


# For a full debian install...
# The following lines purges every application that could be removed in the software center:
# sudo apt purge aisleriot cheese evolution five-or-more four-in-a-row gnome-2048 gnome-calendar gnome-chess gnome-clocks gnome-color-manager
# sudoapt purge gnome-contacts gnome-disk-utility gnome-documents gnome-klotski gnome-logs gnome-mahjongg gnome-maps gnome-mines gnome-music
# sudo apt purge gnome-nibbles gnome-robots gnome-sound-recorder gnome-shell-extension-prefs gnome-sudoku gnome-taquin gnome-tetravex gnome-todo
# sudo apt purge gnome-tweaks gnome-weather hitori iagno im-config libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-writer lightsoff
# sudo apt purge malcontent nautilus quadrapassel rhythmbox seahorse shotwell simple-scan software-properties-gtk swell-foop synaptic tali transmission-gtk

# Next lines  purges the applications that can only be removed through the terminal.
# sudo apt purge aisleriot baobab cheese eog evince evolution file-roller firefox-esr five-or-more four-in-a-row gedit gnome-2048 gnome-calculator
# sudo apt purge gnome-calendar gnome-characters gnome-chess gnome-clocks gnome-color-manager gnome-contacts gnome-disk-utility gnome-documents
# sudo apt purge gnome-font-viewer gnome-klotski gnome-logs gnome-mahjongg gnome-maps gnome-mines gnome-music gnome-nibbles gnome-robots gnome-screenshot
# sudo apt purge gnome-software gnome-sound-recorder gnome-shell-extension-prefs gnome-sudoku gnome-system-monitor gnome-taquin gnome-tetravex gnome-todo
# sudo apt purge gnome-tweaks gnome-weather hitori iagno im-config libreoffice-calc libreoffice-common libreoffice-draw libreoffice-impress
# sudo apt purge libreoffice-writer lightsoff malcontent nautilus quadrapassel rhythmbox seahorse shotwell simple-scan software-properties-gtk swell-foop
# sudo apt purge synaptic tali totem transmission-gtk yelp 
# sudo autoremove xyz

# If you want the Gnome desktop environment without the "extra components", take a look at the Depends.
# Recommends: and Suggests: section and choose which parts you want to manually install
# sudo apt show gnome-core    #gnome


# Choose the components you want,
# Either sudo apt install <pkg>... or sudo apt-mark manual <pkg>... each of these components. This will mark them as "manually installed".
# sudo apt purge gnome to remove the gnome metapackage.
# sudo apt autoremove to remove all of gnome's dependencies which were not manually installed.




