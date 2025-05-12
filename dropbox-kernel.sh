#!/bin/bash

# dropbox-kernel.sh
# 2025-05-11


# My precompiled dropbox Haswell kernel 6.14.3-tkg-bore  (all modules compiled)

USR=$(logname)
DOWNLOAD_DIR="/home/$USR/kernels"


dl_kernel() {
# Dropbox public folder link
DROPBOX_FOLDER_PATH="https://www.dropbox.com/scl/fo/wu8ffjknu506i1ehachss/AHrRWSPCewap_ZEhvXcvQQo?rlkey=eb6clwlaeh9843v39afdbitzb&st=tp72906w&dl=1"


# Create the download directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"
chmod 777 $DOWNLOAD_DIR

# Use curl to download the folder and extract the original file name
sudo apt install -y curl
FOLDER_NAME=$(curl -I "$DROPBOX_FOLDER_PATH" | grep -i "Content-Disposition" | sed -E 's/.*filename="([^"]+)".*/\1/')
DOWNLOAD_PATH="$DOWNLOAD_DIR/$FOLDER_NAME.zip"

# Download the folder contents using curl
curl -L "$DROPBOX_FOLDER_PATH" -o "$DOWNLOAD_PATH"

# Extract the downloaded ZIP file
unzip -d "$DOWNLOAD_DIR" "$DOWNLOAD_PATH"

echo "Files downloaded and extracted to: $DOWNLOAD_DIR"
}


install_kernel() {
    # Change to the download directory
    cd "$DOWNLOAD_DIR"

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
