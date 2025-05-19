#!/bin/bash

# gnome-keyring-setup.sh
# 2025-05-19

# Create the service file
service_file() {
cat << EOF | sudo tee /etc/systemd/system/gnome-keyring-daemon.service || handle_error
[Unit]
Description=GNOME Keyring Daemon
After=dbus.service

[Service]
Type=dbus
BusName=org.gnome.keyring
ExecStart=/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg
Restart=on-failure

[Install]
WantedBy=graphical.target
EOF
}

# Create folder and set permissions
folder_and_permission() {
mkdir -p /home/$USR/.local || handle_error
sudo chown -R $USR:$USR /home/$USR/.local || handle_error
sudo systemctl daemon-reload || handle_error
}

# Reload systemd daemon and enable the service
keyring_daemon() {
sudo systemctl start gnome-keyring-daemon || handle_error
sudo systemctl enable gnome-keyring-daemon.service || handle_error
sudo systemctl status gnome-keyring-daemon.service
#sudo nano /etc/systemd/system/gnome-keyring-daemon.service
}

# Main script execution
service_file
folder_and_permission
keyring_daemon
