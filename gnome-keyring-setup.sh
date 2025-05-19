#!/bin/bash

# gnome-keyring-setup.sh
# 2025-05-19

press_enter() {
echo "Press Enter to continue..."
read -p "" -s
}

# Create the service file
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

# Reload systemd daemon and enable the service
mkdir -p /home/$USR/.local || handle_error
sudo chown -R $USR:$USR /home/$USR/.local || handle_error
sudo systemctl daemon-reload || handle_error
sudo systemctl start gnome-keyring-daemon || handle_error
sudo systemctl enable gnome-keyring-daemon.service || handle_error
sudo systemctl status gnome-keyring-daemon.service
press_enter
#sudo nano /etc/systemd/system/gnome-keyring-daemon.service
