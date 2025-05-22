#!/bin/bash

# stage-2_0.1.sh
# 2025-05-22

stage_2_installer() {
    stage_2="/home/$USR/.config/autostart/stage-2-installer.desktop"
    sudo mkdir "/home/$USR/.config/autostart"
    cat << EOF > "$stage_2"
[Desktop Entry]
Name=Stage 2 customm installer
Exec=/usr/bin/kgx -- /home/jack/debian/extras.sh
Type=Application
X-GNOME-Autostart-Phase=Applications
EOF
}

stage_2_installer
