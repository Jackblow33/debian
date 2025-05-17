#!/bin/bash

# post-install-menu.sh
# 2025-05-17

USR=$(logname)
startup_file="/home/$USR/.config/autostart/software_installer.desktop"
autostart_dir=$(dirname "$startup_file")
menu_script="/home/$USR/debian/post-install/menu-0.4.1.py"

# Create the autostart directory if it doesn't exist
if [ ! -d "$autostart_dir" ]; then
    mkdir -p "$autostart_dir"
fi

# Make the menu-0.4.1.sh script executable
chmod +x "$menu_script"

# Create the startup file
cat << EOF > "$startup_file"
[Desktop Entry]
Name=Software Installer
Exec=python3 /home/$USR/debian/post-install/menu-0.4.1.py
Terminal=false
Type=Application
Hidden=false
EOF

echo "Software Installer gui will now load at boot."
