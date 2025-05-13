#!/bin/bash

# dropbox-kernel-0.2.sh
# 2025-05-12


# My precompiled dropbox Haswell kernel (all modules compiled)

USR=$(logname)
DOWNLOAD_DIR="/home/$USR/kernels"


dl_kernel() {
    # Dropbox public folder link
    DROPBOX_FOLDER_PATH="https://www.dropbox.com/scl/fo/new_folder_path/AHrRWSPCewap_ZEhvXcvQQo?rlkey=eb6clwlaeh9843v39afdbitzb&st=tp72906w&dl=1"

    # Create the download directory if it doesn't exist
    mkdir -p "$DOWNLOAD_DIR"
    chmod 777 "$DOWNLOAD_DIR"

    # Use curl to download the folder and extract the original file name
    sudo apt install -y curl
    FOLDER_NAME=$(echo "$DROPBOX_FOLDER_PATH" | sed -E 's/.*\/([^\/]+)\?.*$/\1/')
    DOWNLOAD_PATH="$DOWNLOAD_DIR/$FOLDER_NAME"
    mkdir -p "$DOWNLOAD_PATH"

    # Download the folder contents using curl
    curl -L "$DROPBOX_FOLDER_PATH" -o "$DOWNLOAD_PATH/$FOLDER_NAME.zip"

    # Extract the downloaded ZIP file
    unzip -d "$DOWNLOAD_PATH" "$DOWNLOAD_PATH/$FOLDER_NAME.zip"

    echo "Files downloaded and extracted to: $DOWNLOAD_PATH"
}


install_kernel() {
    # Change to the download directory
    cd "$DOWNLOAD_PATH"

    # Install the kernel packages using dpkg
    for deb_file in *.deb; do
        sudo dpkg -i "$deb_file"
    done

    # Update the grub configuration
    sudo update-grub

    # Uncomment to reboot the system and load the new kernel
#    echo "Kernel installation complete. Rebooting the system..."
#    sudo reboot
}



# Main script execution
dl_kernel
install_kernel
