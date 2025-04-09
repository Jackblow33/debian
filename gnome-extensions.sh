#!/bin/bash

#Gnome extensions

#dash-to-dock
mkdir ~/.local/share/gnome-shell/extensions/
git clone https://github.com/micheleg/dash-to-dock.git
mv dash-to-dock dash-to-dock@micxgx.gmail.com
cd dash-to-dock@micxgx.gmail.com
sudo make && sudo make install     #Run the following commands to build the extension
cp -r ~/dash-to-dock@micxgx.gmail.com ~/.local/share/gnome-shell/extensions/
#gnome-extensions enable dash-to-dock@micxgx.gmail.com


#freon gnome-shell-extension-sensors
sudo sensors-detect --auto #need lm-sensors dep
sudo apt install  gnome-shell-extension-freon
#gnome-extensions enable freon@UshakovVasilii_Github.yahoo.com


#gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
