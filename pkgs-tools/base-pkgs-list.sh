#!/bin/bash

# base-pkgs-list.sh
# 2025-05-04

# Set the output directory & file path
USR=$(logname)
timestamp=$(date +"%Y-%m-%d-%H-%M")
output_dir="/home/$USR/Downloads/pkgs-tools"
output_file="$output_dir/base_pkgs.list"
mkdir -p $output_dir

# Check if the output file already exists
if [ -f "$output_file" ]; then
    renamed_file="$output_dir/base_pkgs_$timestamp.list"
    mv "$output_file" "$renamed_file"
    echo "Existing file renamed to $renamed_file"
fi

# Get the list of installed packages
installed_packages=$(apt list --installed | cut -d'/' -f1 | tail -n +2)

# Write the package names to the output file
echo "$installed_packages" >> "$output_file"

echo "Cleaned list saved to $output_file"
