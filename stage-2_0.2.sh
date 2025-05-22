#!/bin/bash

# stage-2_0.2.sh
# 2025-05-22

FLAG_FILE="/home/jack/debian/stage-2-installer.flag"

if [ ! -f "$FLAG_FILE" ]; then
    sudo mkdir "/home/jack/.config/autostart
    stage_2="/home/jack/.config/autostart/stage-2-installer.desktop"
    cat << EOF > "$stage_2"
[Desktop Entry]
Name=Stage 2 custom installer
Exec=/usr/bin/kgx -- /home/jack/debian/extras.sh
Type=Application
X-GNOME-Autostart-Phase=Applications
EOF

    # Create the flag file to indicate that the script has been run
    touch "$FLAG_FILE"
fi
