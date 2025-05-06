#!/bin/bash

# Set the script name and path
SCRIPT_NAME="Gaming Script"
SCRIPT_PATH="/usr/local/bin/gaming"
FLAG_FILE="/tmp/gaming_script_executed"

# Check if the script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: $SCRIPT_PATH does not exist."
    exit 1
fi

# Check if the script is executable
if [ ! -x "$SCRIPT_PATH" ]; then
    echo "Error: $SCRIPT_PATH is not executable."
    exit 1
fi

# Check if the desktop session is GNOME
DESKTOP_SESSION=$(loginctl show-session "$XDG_SESSION_ID" -p Type | cut -d'=' -f2)
if [ "$DESKTOP_SESSION" != "gnome" ]; then
    echo "Error: This script is only for GNOME desktop sessions."
    exit 1
fi

# Check if the script has already been executed
if [ -f "$FLAG_FILE" ]; then
    echo "The gaming script has already been executed. Exiting."
    exit 0
fi

# Create the startup application
dbus-launch --exit-with-session \
    gsettings set org.gnome.startup-applications registered \
    "[{'name':'$SCRIPT_NAME','command':'$SCRIPT_PATH','comment':'Automatically added by a script'}]"

# Create the flag file to indicate that the script has been executed
touch "$FLAG_FILE"

echo "Startup application '$SCRIPT_NAME' has been added."
