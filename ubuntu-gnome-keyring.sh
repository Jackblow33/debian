#!/usr/bin/env bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
CHECK_MARK=$'\e[1;32m\u2714\e[0m'
CROSS_MARK=$'\e[1;31m\u2718\e[0m'
CIRCLE=$'\u25CB'

# Helper functions
print_message() {
    echo -e "${GREEN}[*] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

print_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

execute_command() {
    local cmd="$1"
    local description="$2"

    echo -e "Executing: $cmd"
    eval "$cmd"
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        print_warning "Command for '$description' failed."
    fi
    return $exit_code
}

configure_gnome_keyring() {
    print_message "Configuring gnome-keyring"

    if [ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "plasma" ] || pgrep -x "plasmashell" > /dev/null; then
        print_message "KDE environment detected. Skipping gnome-keyring configuration."
        return 0
    fi

    if ! command -v gnome-keyring-daemon >/dev/null 2>&1; then
        print_warning "gnome-keyring is not installed. Installing..."
        if command -v pacman >/dev/null 2>&1; then
            execute_command "sudo pacman -S --noconfirm gnome-keyring" "Install gnome-keyring"
        elif command -v apt >/dev/null 2>&1; then
            execute_command "sudo apt install -y gnome-keyring" "Install gnome-keyring"
        elif command -v dnf >/dev/null 2>&1; then
            execute_command "sudo dnf install -y gnome-keyring" "Install gnome-keyring"
        else
            print_error "Unsupported package manager. Please install gnome-keyring manually."
            return 1
        fi
    else
        print_message "gnome-keyring is already installed."
    fi

    if ! grep -q "pam_gnome_keyring.so" /etc/pam.d/login; then
        print_message "Adding PAM configurations for gnome-keyring to /etc/pam.d/login..."
        execute_command "echo 'auth optional pam_gnome_keyring.so' | sudo tee -a /etc/pam.d/login > /dev/null" "Add auth line to PAM"
        execute_command "echo 'session optional pam_gnome_keyring.so auto_start' | sudo tee -a /etc/pam.d/login > /dev/null" "Add session line to PAM"
    else
        print_message "PAM configuration for gnome-keyring already exists in /etc/pam.d/login."
    fi

    print_message "Starting gnome-keyring-daemon..."
    if pgrep -x gnome-keyring-daemon >/dev/null; then
        print_message "gnome-keyring-daemon already running."
    else
        execute_command "/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh &>/dev/null &" "Start gnome-keyring-daemon"
    fi

    print_message "GNOME Keyring configuration completed successfully!"
}

# Run the function
configure_gnome_keyring
