#!/bin/bash

# Override volume default = 40% to default = 100%

USR=$(logname)

update_wireplumber_config() {
    # Get the current user's home directory
    home_dir="/home/$USR"
    file_path="/home/$USR/.config/wireplumber/wireplumber.conf"
    config_file="$home_dir/.config/wireplumber/wireplumber.conf"

    # Check if the file exists
    if [ -f "$config_file" ]; then
        # Backup the original file
        backup_file="$config_file.bak"
        cp "$config_file" "$backup_file"

        # Replace the default value
        sed -i 's/default = 0.064/default = 1.0/g' "$config_file"

        echo "The wireplumber.conf file has been updated."
        echo "A backup of the original file has been created at $backup_file."
    else
        echo "The wireplumber.conf file does not exist in $home_dir/.config/wireplumber/"
    fi
}

# Call the function
update_wireplumber_config
