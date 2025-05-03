#!/bin/bash

# pkgs-list.sh

USR=$(logname)

# Set the output file path
output_file="/home/$USR/debian/pkgs-tools/full_pkgs.list"

# Get the list of installed packages
installed_packages=$(apt list --installed | cut -d'/' -f1 | tail -n +2)

# Write the package names to the output file
echo "$installed_packages" >> "$output_file"

echo "Cleaned list saved to $output_file"

