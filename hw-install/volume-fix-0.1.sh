#!/bin/bash

# Override volume default = 40% to default = 100%

USR=$(logname)

update_wireplumber_config() {
    home_dir="/home/$USR"
    config_file="$home_dir/.config/wireplumber/wireplumber.conf"
    dir="$home_dir/.config/wireplumber"

    # Check if the directory exists
    if [ ! -d "$dir" ]; then
        # Create directory if it does not exist
        mkdir -p "$dir" || { echo "Failed to create directory: $dir"; exit 1; }
        echo "Directory created: $dir"
    else
        echo "Directory already exists: $dir"
    fi
    
    # Check if the file exists
    if [ -f "$config_file" ]; then
        # Backup the original file
        backup_file="$config_file.bak"
        cp "$config_file" "$backup_file" || { echo "Failed to create backup: $backup_file"; exit 1; }

        # Replace the default value
        sed -i 's/default = 0.064/default = 1.0/g' "$config_file" || { echo "Failed to update $config_file"; exit 1; }

        echo "The wireplumber.conf file has been updated."
        echo "A backup of the original file has been created at $backup_file."
    else
        echo "The wireplumber.conf file does not exist in $home_dir/.config/wireplumber/"
    fi
}

# Call the function
update_wireplumber_config
