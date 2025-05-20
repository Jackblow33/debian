#!/bin/bash


# Check the contents of the /etc/apt/sources.list file
if grep -q "trixie" /etc/apt/sources.list; then
    echo "This system is running Debian Trixie."

    # Check if contrib and non-free repositories are present
    if ! grep -q "contrib" /etc/apt/sources.list || ! grep -q "non-free" /etc/apt/sources.list; then
        echo "Adding contrib and non-free repositories to /etc/apt/sources.list..."
        sudo sed -i 's/trixie main/trixie main contrib non-free/g' /etc/apt/sources.list
        sudo apt update
        sudo nano /etc/apt/sources.list
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


# Check the contents of the /etc/apt/sources.list and determine if trixie or sid
if grep -q "trixie" /etc/apt/sources.list; then
    echo "This system is running Debian Trixie."
    echo ''; echo ''; echo '';
    read -p "Press Enter"
    # Add custom action code here
elif grep -q "sid" /etc/apt/sources.list; then
    echo "This system is running Debian Sid."
    echo ''; echo ''; echo '';
    read -p "Press Enter"
else
    echo "This system is not running Debian Trixie or Debian Sid."
    echo ''; echo ''; echo '';
    read -p "Press Enter"
fi


#TRY THIS

    # Check if contrib and non-free repositories are present
    if ! grep -q "contrib" /etc/apt/sources.list || ! grep -q "non-free" /etc/apt/sources.list; then
        echo "Adding contrib and non-free repositories to /etc/apt/sources.list..."
        sudo sed -i 's/trixie main/trixie main contrib non-free/g' /etc/apt/sources.list
        sudo apt update
        sudo nano /etc/apt/sources.list
    else
        echo "contrib and non-free repositories are already present in /etc/apt/sources.list."
    fi

elif grep -q "sid" /etc/apt/sources.list; then
    echo "This system is running Debian Sid."
else
    echo "This system is not running Debian Trixie or Debian Sid."
fi






else
    echo "This system is not running Debian Trixie or Debian Sid."
fi


