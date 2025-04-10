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



###appindicator -Compilation works
#cd ~/
#sudo apt-get install ninja-build meson    #build-essential  lm-sensors
#git clone https://github.com/ubuntu/gnome-shell-extension-appindicator.git
###workaround patch for metadata.json file to support gnome 48
#patch ~/gnome-shell-extension-appindicator/metadata.json ~/debianmultiscripts/appindicator.diff
###Patch or: gsettings set org.gnome.shell disable-extension-version-validation true
#meson gnome-shell-extension-appindicator /tmp/g-s-appindicators-build
#ninja -C /tmp/g-s-appindicators-build install

#gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
