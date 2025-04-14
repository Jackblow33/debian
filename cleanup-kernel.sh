#!/bin/bash

# Get the currently running kernel
current_kernel=$(uname -r)

# Get a list of installed kernels
installed_kernels=$(dpkg --list | grep linux-image | awk '{print $2}')

# Create an array to hold the kernels to remove
kernels_to_remove=()

# Loop through installed kernels and add to the removal list if not the current one
for kernel in $installed_kernels; do
    if [[ "$kernel" != *"$current_kernel"* ]]; then
        kernels_to_remove+=("$kernel")
    fi
done

# Check if there are any kernels to remove
if [ ${#kernels_to_remove[@]} -eq 0 ]; then
    echo "No old kernels to remove. You are only using the current kernel."
    exit 0
fi

# Display the kernels available for removal
echo "Installed kernels (excluding the current one):"
for i in "${!kernels_to_remove[@]}"; do
    echo "$i: ${kernels_to_remove[$i]}"
done

# Prompt user for which kernels to delete
echo "Enter the numbers of the kernels you want to delete (comma-separated, e.g., 0,1):"
read -r user_input

# Convert user input into an array
IFS=',' read -r -a kernels_to_delete_indices <<< "$user_input"

# Remove the selected kernels
for index in "${kernels_to_delete_indices[@]}"; do
    if [[ $index =~ ^[0-9]+$ ]] && [ "$index" -lt "${#kernels_to_remove[@]}" ]; then
        kernel_to_delete=${kernels_to_remove[$index]}
        echo "Removing kernel: $kernel_to_delete"
        sudo apt-get purge -y "$kernel_to_delete"
    else
        echo "Invalid input: $index"
    fi
done

# Clean up
sudo apt-get autoremove -y

# GRUB bootloader update
echo "Updating GRUB..."
sudo update-grub

echo "Kernel removal process completed."
