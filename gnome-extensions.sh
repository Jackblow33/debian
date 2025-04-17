#!/bin/bash

# Gnome extensions install

# Dash to Dock
EXTENSION_NAME="dash-to-dock@micxgx.gmail.com"
EXTENSION_DIR="/home/$USR/.local/share/gnome-shell/extensions/$EXTENSION_NAME"

# Check if the extension is already installed
if [ -d "$EXTENSION_DIR" ]; then
    echo "Dash to Dock extension is already installed."
else
    # Install Dash to Dock extension
    echo "Installing Dash to Dock extension..."
    mkdir -p "$EXTENSION_DIR" || handle_error
    git clone https://github.com/micheleg/dash-to-dock.git "$EXTENSION_DIR" || handle_error
    cd "$EXTENSION_DIR" || handle_error
    make || handle_error
    make install || handle_error
    echo "Dash to Dock extension installed."
fi

# Disable hot corners
# Check if GNOME is running
if pgrep -x "gnome-shell" > /dev/null; then
    # Disable hot corners
    gsettings set org.gnome.desktop.interface enable-hot-corners false || handle_error
    echo "Hot corners disabled in GNOME."
else
    # Modify GNOME configuration file directly
    if [ -f "/home/$USR/.config/dconf/user" ]; then
        dconf write /org/gnome/desktop/interface/enable-hot-corners false || handle_error
        echo "Hot corners disabled in GNOME configuration file."
    else
        echo "GNOME is not running and the configuration file was not found."
    fi
fi








# dash-to-dock
mkdir '/home/'$USR'/.local/share/gnome-shell/extensions/'
git clone https://github.com/micheleg/dash-to-dock.git
mv dash-to-dock dash-to-dock@micxgx.gmail.com
cd dash-to-dock@micxgx.gmail.com
sudo make && sudo make install     #Run the following commands to build the extension
cp -r '/home/'$USR'/dash-to-dock@micxgx.gmail.com /home/$USR/.local/share/gnome-shell/extensions/'
echo "Press [enter] "; read enterKey

# dash to panel
cd /home/$USR
git clone https://github.com/home-sweet-gnome/dash-to-panel.git
cd /home/$USR/dash-to-panel
make install
cd ..
mv '/home/'$USR'/dash-to-panel dash-to-panel@jderose9.github.com'
cp -r '/home/'$USR'/dash-to-panel@jderose9.github.com /home/$USR/.local/share/gnome-shell/extensions/'
echo "Press [enter] "; read enterKey

#freon gnome-shell-extension-sensors
sudo sensors-detect --auto
sudo apt install  gnome-shell-extension-freon

# appindicator -Compilation works
#USR=jack #### REMOVE before commit
#cd /home/$USR
#apt-get install ninja-build meson    #build-essential  lm-sensors
#git clone https://github.com/ubuntu/gnome-shell-extension-appindicator.git
#cd gnome-shell-extension-appindicator
#meson gnome-shell-extension-appindicator /tmp/g-s-appindicators-build
#ninja -C /tmp/g-s-appindicators-build install
#echo "Press [enter] "; read enterKey

echo "Press [enter] to reboot"; read enterKey
sudo shutdown -r now













# Enable extensnsions and customize
#gsettings set org.gnome.shell disable-extension-version-validation true
#gnome-extensions enable dash-to-dock@micxgx.gmail.com
#gnome-extensions enable dash-to-panel@jderose9.github.com
#gnome-extensions enable freon@UshakovVasilii_Github.yahoo.com
#gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
#gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
#gsettings set org.gnome.shell.extensions.dash-to-dock show-volume false
#gsettings set org.gnome.shell.extensions.dash-to-dock show-device false
#gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false

#This will return a list of app IDs that are currently pinned and help you generate the next command line following that one
#gsettings get org.gnome.shell favorite-apps
#gsettings set org.gnome.shell favorite-apps "['firefox-esr.desktop', 'org.gnome.gedit.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop']" ### ADD varible to choosed web browser









###workaround patch for metadata.json file to support gnome 48
#patch ~/gnome-shell-extension-appindicator/metadata.json ~/debianmultiscripts/appindicator.diff
###Patch or: gsettings set org.gnome.shell disable-extension-version-validation true
#gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
