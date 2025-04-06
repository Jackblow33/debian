#!/bin/bash
########################################################################
# ENTER THE FOLLOWING COMMANDS AS USER BEFORE LOADING THIS SCRIPT ######
########################################################################
#Run as user: So no sudo su.....                                       #
#PATH=/home/$USER/github                                               #
#sudo apt modernize-sources                                            #
#sudo apt update && sudo apt upgrade                                   #
#sudo apt install git -y                                               #
#mkdir $PATH                                                           #
#chmod 700 $PATH          # give user Read/Write/execute permissions   #
#cd $PATH                                                              #
#sudo git clone https://github.com/Jackblow33/DebianMultiScripts.git   #
#cd DebianMultiScripts                                                 #
#chmod +x *.sh  # permission setting executable                        #
#./BaseDebian.sh         # Execute Script                              #
########################################################################

#VARIABLES
# Colors
GREEN='\033[0;32m'
NC='\033[0m' #no color

#VARIABLES
TIMESTAMP=`date +%Y%m%d.%R`

#VARIABLES
# Packages install
PKGS=(
        'kde-plasma-desktop'        # KDE Plasma Desktop
        'plasma-discover'           # Graphical software manager
        'plasma-pa'                 # Applet for audio volume
        'kmenuedit'                 # Menu editor
        'firefox-esr'               # Web browser
        'fastfetch'                 # Fetching system information in terminal
        'numlockx'                  # Turn NumLock on
        'gparted'                   # Partition utility
        'ark'                       # Ark manages various archive formats
        'unrar'                     # UnRar
        'rar'                       # Rar
        'timeshift'                 # Timeshift is a program used to make system back-ups/snapshots easily
        'vlc'                       # VLC is free software to play, transcode and broadcast video and audio files
#        'kde-config-sddm'           # Login Screen (SDDM) System Settings Module
#        'software-properties-qt'    # allows you to easily manage your distribution and independent software vendor software sources
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
#Updating package if necessary
sudo apt modernize-sources
sudo apt update && sudo apt upgrade      #|| sudo pacman -Sy && sudo pacman -Syu

echo
echo "Base KDE Plasma instalation"
echo

read -p "Press Enter to start KDE installation............................>>>"

#Enabling additional repos  -untested
#cp /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources_$TIMESTAMP
#sed -i 's/^Components: main$/& contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources
#sudo apt update

#Packages installer
for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo apt install "$PKG" #-y #|| sudo pacman -S "$PKG" --noconfirm --needed
done

#Removing some packages
        sudo apt purge zutty kwalletmanager kdeconnect partitionmanager -y  #|| Arch
------------------------------------------------------------------------------------------------------
#remove apps -untested
        sudo apt purge ifupdown
#untested
sudo sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf  #Editing NetworkManager file: managed=false to managed=true
#Check system|network|IPv4 and make sure static ip address or dhcp is set properly
-----------------------------------------------------------------------------------------------------
    #Turn NumLock on - numlockx KDE
    #Make a copy of sddm.conf before edit
    cp /etc/sddm.conf /etc/sddm.conf.$TIMESTAMP
    sudo /bin/sh -c 'echo "Numlock=on" >> /etc/sddm.conf' #|| Arch
    
    #fastfetch auto load in terminal
    #Make a copy of .bashrc before edit
    cp ~/.bashrc ~/.bashrc.$TIMESTAMP
    echo "fastfetch" >> ~/.bashrc  #|| Arch

#add check for install successful
echo
echo -e "${GREEN}Installation ran sucessfully!${NC}"
echo
timer_stop
#error check
read -p "$(echo -e $GREEN"Installation completed! Press Enter to reboot............................>>> "$NC)"

#Enable Network manager
     sudo systemctl enable NetworkManager
     sudo systemctl start NetworkManager
#Enable sddm so it get started on boot
    sudo systemctl enable sddm
#Boot    
#    sudo systemctl start sddm
sudo reboot

    
    ### Jackblow33 2025 #####################



    
    
   
### TODO ###

# Battery & power profile auto setup for laptop and desktop
# Cleanup menu and add menu editor config file + remove kmenuedit from install script + up config file to github
# Automated option to remove or not screen brightnest applet | laptop vs desktop with command hostnamectl
# deactivate top left screen edge /overview set to no action  #https://github.com/shalva97/kde-configuration-files?tab=readme-ov-file#screen-edges
# add commands from postinstall document
# add error checking, press enter, reboot
# unpin konquerer from task bar | pin firefox Konsole   #https://github.com/shalva97/kde-configuration-files
# remove konsole exit confirmation
# set google as default home page in firefox
# install without emoji, konquerer, kedit - for now hidden from menu but still present...
