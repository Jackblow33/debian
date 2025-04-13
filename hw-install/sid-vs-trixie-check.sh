#!/bin/bash

# THIS DOESN't work
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


#TRY THIS

    # Check if contrib and non-free repositories are present
    if ! grep -q "contrib" /etc/apt/sources.list || ! grep -q "non-free" /etc/apt/sources.list; then
        echo "Adding contrib and non-free repositories to /etc/apt/sources.list..."
        sudo sed -i 's/bullseye main/bullseye main contrib non-free/g' /etc/apt/sources.list
        sudo apt update
    else
        echo "contrib and non-free repositories are already present in /etc/apt/sources.list."
    fi

elif grep -q "sid" /etc/apt/sources.list; then
    echo "This system is running Debian Sid."
else
    echo "This system is not running Debian Trixie or Debian Sid."
fi

# BIG ONE

#!/bin/bash

# Check the contents of the /etc/apt/sources.list file
if grep -q "trixie" /etc/apt/sources.list; then
    echo "This system is running Debian Trixie."

    # Check if contrib and non-free repositories are present
    if ! grep -q "contrib" /etc/apt/sources.list || ! grep -q "non-free" /etc/apt/sources.list; then
        echo "Adding contrib and non-free repositories to /etc/apt/sources.list..."
        sudo sed -i 's/trixie main/trixie main contrib non-free/g' /etc/apt/sources.list
        sudo apt update
    else
        echo "contrib and non-free repositories are already present in /etc/apt/sources.list."
    fi

elif grep -q "sid" /etc/apt/sources.list; then
    echo "This system is running Debian Sid."

    # Check if contrib and non-free repositories are present
    if ! grep -q "contrib" /etc/apt/sources.list || ! grep -q "non-free" /etc/apt/sources.list; then
        echo "Adding contrib and non-free repositories to /etc/apt/sources.list..."
        sudo sed -i 's/sid main/sid main contrib non-free/g' /etc/apt/sources.list
        sudo apt update
    else
        echo "contrib and non-free repositories are already present in /etc/apt/sources.list."
    fi

else
    echo "This system is not running Debian Trixie or Debian Sid."
fi


