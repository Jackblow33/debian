#!/bin/bash

# stage-2.sh
# 2025-05-21

# Handle errors
handle_error() {
    echo "Error occurred in the script. Exiting."
    exit 1
}

stage_2_installer() {
    stage_2="/etc/systemd/system/stage-2-installer.service"
    cat << EOF > "$stage_2" || handle_error
[Unit]
Description=Stage 2 custom installer script
After=graphical.target
Wants=graphical.target

[Service]
ExecStart=/usr/bin/kgx -- /home/jack/debian/extras.sh
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=graphical.target
EOF
# ExecStart=/usr/bin/gnome-console -- /home/jack/debian/extras.sh
    sudo systemctl daemon-reload || handle_error
    sudo systemctl enable stage-2-installer.service || handle_error
    sudo systemctl start stage-2-installer.service || handle_error
}

stage_2_installer
