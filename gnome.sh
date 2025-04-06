#!/bin/bash

#https://wiki.debian.org/Gnome  &&  https://www.youtube.com/watch?v=zy-5UHC3t-Q



#VARIABLE
PKGS=(
        'gnome-core'                #  Core components of the GNOME Desktop environment
        'gedit'                     # Text editor
        'make'                      # general purpose dependency solver
        'gettext'                   # build depends for dash-to-dock
        'sassc'                     # build depends for dash-to-dock
        'fastfetch'                 # Fetching system information in terminal
        'gparted'                   # Partition utility
        'timeshift'                 # Timeshift is a program used to make system back-ups/snapshots easily
        'vlc'                       # VLC is free software to play, transcode and broadcast video and audio files
)

#fonctions
timer_start()
{
BEGIN=$(date +%s)
}

#fonctions
timer_stop()
{
    NOW=$(date +%s)
    let DIFF=$(($NOW - $BEGIN))
    let MINS=$(($DIFF / 60))
    let SECS=$(($DIFF % 60))
    echo Time elapsed: $MINS:`printf %02d $SECS`
}


timer_start
sudo apt update && sudo apt upgrade

#Packages installer
for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo apt install "$PKG" #-y #|| sudo pacman -S "$PKG" --noconfirm --needed
done

#remove apps
sudo apt purge ifupdown gnome-text-editor -y && sudo apt autoremove gnome-text-editor -y

sudo sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf  #Editing NetworkManager file: managed=false to managed=true
#Check system|network|IPv4 and make sure static ip address or dhcp is set properly

timer_stop
echo "Press [enter] to reboot"; read enterKey
sudo shutdown -r now      #reboot
