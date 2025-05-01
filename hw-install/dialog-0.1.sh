#!/bin/bash

# Function to display the NVIDIA driver installation warning!
display_nvidia_warning() {
    local MESSAGE="To blacklist nouveau driver, the file: /etc/modprobe.d/blacklist-nouveau.conf gonna be created.\n\n\n\
To fix some power management issues, the file: /etc/modprobe.d/nvidia-power-management.conf gonna be created.\n\n\n\
nvidia-drm.modeset=1 gonna be added to grub at line: GRUB_CMDLINE_LINUX_DEFAULT in /etc/default.\n\n\n\
And of course you're gonna taint your kernel with the nvidia proprietary driver!!!\n\n\n\
Would you like to continue? Yes or No."

    # Display the message in a yes/no dialog
    if (whiptail --title "NVIDIA Driver Installation Warning" --yesno "$MESSAGE" 24 70); then
        echo "User chose to continue."
        # Add commands here to create the files and modify grub if needed
    else
        echo "User chose not to continue."
        exit 1
    fi
}


display_nvidia_warning
