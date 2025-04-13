#!/bin/bash

# Check the contents of the /etc/apt/sources.list file
if grep -q "bullseye" /etc/apt/sources.list; then
    echo "This system is running Debian Trixie."
    # Add action for Debian Trixie here
    echo "Performing action for Debian Trixie..."
    # Add custom action code here
elif grep -q "sid" /etc/apt/sources.list; then
    echo "This system is running Debian Sid."
else
    echo "This system is not running Debian Trixie or Debian Sid."
fi
