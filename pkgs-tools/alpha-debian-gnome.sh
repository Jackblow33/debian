#!/bin/bash

# Debian sid base gnome desktop environment packages installer (Linux from scratch).

# Set the input file path
#USR=$(logname)
input_file="/home/$USR/pkgs-tools/tasksel_pkgs.list"
# Install the packages
sudo apt-get install -y $(cat "$input_file")
