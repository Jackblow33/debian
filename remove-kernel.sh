#!/bin/bash

# Get the currently running kernel
current_kernel=$(uname -r)

# Get a list of installed kernels
installed_kernels=$(dpkg --list | grep linux-image | awk '{print $2}')

# Set the number of kernels to keep
kernels_to_keep=2

# Create an array to hold the kernels to remove
kernels_to_remove=()

# Loop through installed kernels
for kernel in $installed_kernels; do
    # Check if the kernel is the current one
    if [[ "$kernel" != *"$current_kernel"* ]]; then
        # Add to the removal list
        kernels_to_remove+=("$kernel")
    fi
done

# Sort the kernels to remove and keep the latest ones
kernels_to_remove_sorted=($(printf "%s\n" "${kernels_to_remove[@]}" | sort -V))
kernels_to_remove_count=${#kernels_to_remove_sorted[@]}

# Calculate how many kernels to remove
kernels_to_delete=$((kernels_to_remove_count - kernels_to_keep))

# Remove the old kernels
if [ $kernels_to_delete -gt 0 ]; then
    echo "Removing the following old kernels:"
    for kernel in "${kernels_to_remove_sorted[@]:0:$kernels_to_delete}"; do
        echo " - $kernel"
        sudo apt-get purge -y "$kernel"
    done
else
    echo "No old kernels to remove. Keeping the latest $kernels_to_keep kernels."
fi

# Clean up
sudo apt-get autoremove -y
