#!/bin/bash

USR=$(logname)

# Set the directory where the files are located
dir="/home/$USR/debian/pkgs-tools"

# Set the names of the files
full_pkgs_file="full_pkgs.list"
base_pkgs_file="base_pkgs.list"
final_pkgs_file="pkgs.list"

# Check if the files exist
if [ -f "$dir/$full_pkgs_file" ] && [ -f "$dir/$base_pkgs_file" ]; then
    # Compare the contents of the two files and generate the final list
    comm -23 "$dir/$full_pkgs_file" "$dir/$base_pkgs_file" > "$dir/$final_pkgs_file"
    echo "The final list of packages has been generated in $dir/$final_pkgs_file."
else
    echo "One or both of the files do not exist in $dir."
fi

