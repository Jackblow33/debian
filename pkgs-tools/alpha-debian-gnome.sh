#!/bin/bash

# Debian sid base gnome desktop environment packages installer over a base minimal installation.

USR=$(logname)
LOG_DIR="/home/$USR/debian/LOGS"
LOG_FILE="install.log"
mkdir $LOG_DIR
input_file="/home/$USR/debian/pkgs-tools/tasksel_pkgs.list"

start_time=$SECONDS

if ! whiptail --title "Debian 13 sid Installation" --yesno "You are about to install Debian 13 sid packages. Would you like to proceed?" 8 60; then
    echo "Installation cancelled."
    exit 1
fi

# Install the packages
sudo apt-get install -y $(cat "$input_file")

end_time=$SECONDS
elapsed_time=$((end_time - start_time))
elapsed_minutes=$((elapsed_time / 60))
elapsed_seconds=$((elapsed_time % 60))

total_time_message="Gnone install, total time elapsed: $elapsed_minutes minutes and $elapsed_seconds seconds."
echo "$total_time_message" >> "$LOG_DIR/$LOG_FILE"

echo "$total_time_message"


