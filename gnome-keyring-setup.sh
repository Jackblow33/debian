#!/bin/bash

# gnome-keyring-setup.sh
# 2025-05-18

sudo nano /etc/systemd/system/gnome-keyring-daemon.service

# Create the service file
cat << EOF | sudo tee /etc/systemd/system/gnome-keyring-daemon.service
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

# Reload systemd daemon and enable the service
#sudo systemctl daemon-reload
#sudo systemctl start gnome-keyring-daemon
#sudo systemctl enable gnome-keyring-daemon.service
