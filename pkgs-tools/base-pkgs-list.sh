#!/bin/bash

# pkgs-list.sh
# 2025-05-04

# Set the output directory & file path
USR=$(logname)
timestamp=$(date +"%Y-%m-%d-%H-%M")
output_dir="/home/$USR/Downloads/pkgs-tools"
mkdir -p $output_dir

# Determine the package list type based on the number of installed packages (lest then 500 = base / more then 500 = full)
installed_packages=$(dpkg --get-selections | awk '{print $1}' | wc -l)
if [ $installed_packages -lt 500 ]; then
    output_file="$output_dir/base_pkgs.list"
    package_list=$(apt list --installed | cut -d'/' -f1 | tail -n +2)
else
    output_file="$output_dir/full_pkgs.list"
    package_list=$(dpkg --get-selections | awk '{print $1}')
fi

# Check if the output file already exists
if [ -f "$output_file" ]; then
    renamed_file="${output_file%.*}_$timestamp.list"
    mv "$output_file" "$renamed_file"
    echo "Existing file renamed to $renamed_file"
fi

# Write the package names to the output file
echo "$package_list" >> "$output_file"

echo "Package list saved to $output_file"
