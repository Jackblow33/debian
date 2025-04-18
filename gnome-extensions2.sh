#!/bin/bash
#2025-04-17

# Dash to Dock extension enable by default with custom settings

# Install gnome-shell-extension-manager
apt install gnome-shell-extension-prefs || handle_error

# Enable extensions and customize
ENABLE_EXTENSIONS=true
# If ENABLE_EXTENSIONS is set to false, the script will install the extensions without customizing and not enabling them.
# Could be enable manually after the install via the gnome-shell-extension-manager app.

# Dash to Panel extension
PANEL_EXTENSION_NAME="dash-to-panel@jderose9.github.com"
PANEL_EXTENSION_DIR="/home/$USR/.local/share/gnome-shell/extensions/$PANEL_EXTENSION_NAME"

# Dash to Dock extension
DOCK_EXTENSION_NAME="dash-to-dock@micxgx.gmail.com"
DOCK_EXTENSION_DIR="/home/$USR/.local/share/gnome-shell/extensions/$DOCK_EXTENSION_NAME"

# Freon extension
FREON_EXTENSION_NAME="freon@UshakovVasilii_Github.yahoo.com"

# Check if the user is running GNOME
if [ "$XDG_CURRENT_DESKTOP" != "GNOME" ]; then
    echo "This script is designed for GNOME desktop environment."
    read -p "Press Enter to exit and return to the main menu..."
    handle_error
fi

if [ "$INSTALL_EXTENSIONS" = true ]; then
    # Install and enable Dash to Panel extension
    if [ -d "$PANEL_EXTENSION_DIR" ]; then
        echo "Dash to Panel extension is already installed."
    else
        echo "Installing Dash to Panel extension..."
        mkdir -p "$PANEL_EXTENSION_DIR" || handle_error
        git clone https://github.com/home-sweet-gnome/dash-to-panel.git "$PANEL_EXTENSION_DIR" || handle_error
        cd "$PANEL_EXTENSION_DIR" || handle_error
        make || handle_error
        make install || handle_error
        echo "Dash to Panel extension installed."
    fi

    echo "Enabling Dash to Panel extension..."
    if gnome-extensions-app enable "$PANEL_EXTENSION_NAME"; then
        echo "Dash to Panel extension has been enabled."
    else
        echo "Failed to enable Dash to Panel extension."
    fi

    # Install and enable Dash to Dock extension
    if [ -d "$DOCK_EXTENSION_DIR" ]; then
        echo "Dash to Dock extension is already installed."
    else
        echo "Installing Dash to Dock extension..."
        mkdir -p "$DOCK_EXTENSION_DIR" || handle_error
        git clone https://github.com/micheleg/dash-to-dock.git "$DOCK_EXTENSION_DIR" || handle_error
        cd "$DOCK_EXTENSION_DIR" || handle_error
        make || handle_error
        make install || handle_error
        echo "Dash to Dock extension installed."
    fi

    echo "Enabling Dash to Dock extension..."
    if gnome-extensions-app enable "$DOCK_EXTENSION_NAME"; then
        echo "Dash to Dock extension has been enabled."
    else
        echo "Failed to enable Dash to Dock extension."
    fi

    if [ "$PANEL_EXTENSION_NAME" != "" ] && [ "$DOCK_EXTENSION_NAME" != "" ]; then
        echo "Both Dash to Panel and Dash to Dock extensions have been installed and enabled."
    elif [ "$PANEL_EXTENSION_NAME" != "" ]; then
        echo "Dash to Panel extension has been installed and enabled."
    elif [ "$DOCK_EXTENSION_NAME" != "" ]; then
        echo "Dash to Dock extension has been installed and enabled."
    else
        echo "No extensions were installed or enabled."
    fi
else
    echo "Installation of Dash to Panel and Dash to Dock extensions skipped."
fi

# Prepare lm-sensors to generate values for freon extension
echo "Setting up lm-sensors..."
sensors-detect --auto || handle_error
#freon gnome-shell-extension-sensors install
apt install  gnome-shell-extension-freon || handle_error

if [ "$ENABLE_EXTENSIONS" = true ]; then
    echo "Enabling extensions and customizing settings..."
#    gnome-extensions-app enable "$PANEL_EXTENSION_NAME" || handle_error
    gnome-extensions-app enable "$DOCK_EXTENSION_NAME" || handle_error
    gnome-extensions-app enable "$FREON_EXTENSION_NAME" || handle_error
    gsettings set org.gnome.shell disable-extension-version-validation true || handle_error
    gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close' || handle_error
    gsettings set org.gnome.shell.extensions.dash-to-dock show-volume false  || handle_error
    gsettings set org.gnome.shell.extensions.dash-to-dock show-device false  || handle_error
    gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false  || handle_error
    gsettings set org.gnome.desktop.interface enable-hot-corners false || handle_error
fi

echo "Script execution complete."
read -p "Press Enter to exit..."
exit
