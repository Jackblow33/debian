#!/bin/bash

# modeprobed-db.sh
# Date modified: 2025-04-27


# Root_check
root_check() {
    if [ "$EUID" -ne 0 ]; then
        echo "This script must be run as root."
        exit 1
    fi
}



git_build() {
    git clone https://github.com/graysky2/modprobed-db.git /home/$USR/github/modeprobed-db || handle_error
    cd /home/$USR/github/modeprobed-db
    make & make install || handle_error
    # Initialize modprobed-db to create a modules database: /home/$USR/.config/modeprobed.db
    modprobed-db --version  #; sleep 3 || handle_error
    echo -e "\033[0;32mmodprobed-db Ready ...\033[0m"
    # Scan for modules
    modprobed-db store || handle_error
    echo -e "\033[0;32mDone ...\033[0m"
}


# Create cron task. Every hour execute modprobed-db
cron_task() {
    apt install -y cronie
    ###crontab -e
    #echo '0 */1 * * *   /usr/bin/modprobed-db store &> /dev/null' >>
    # Check synthax of crontab files

LOG_FILE="/var/log/modprobed-db.log"
    if [ ! -f "$LOG_FILE" ]; then
        sudo touch "$LOG_FILE"
        sudo chmod 644 "$LOG_FILE"
    fi

# Directory to check
CRON_DIR="/var/spool/cron/crontabs"

# Line to add to the files
#CRON_LINE="0 */1 * * *   /usr/bin/modprobed-db store &> /dev/null"
CRON_LINE="0 */1 * * * /usr/bin/modprobed-db store >> /var/log/modprobed-db.log 2>&1 &> /dev/null"

# Check if the "root" file exists
if [ -f "$CRON_DIR/root" ]; then
    # Create a backup of the "root" file with a timestamp
    cp "$CRON_DIR/root" "$CRON_DIR/root.$TIMESTAMP"
    echo "Backed up $CRON_DIR/root to $CRON_DIR/root.$TIMESTAMP"
fi

# Check if the "user" file exists
if [ -f "$CRON_DIR/$USR" ]; then
    # Create a backup of the "user" file with a timestamp
    cp "$CRON_DIR/$USR" "$CRON_DIR/$USR.$TIMESTAMP"
    echo "Backed up $CRON_DIR/$USR to $CRON_DIR/$USR.$TIMESTAMP"
fi

# Check if the "root" file exists
if [ ! -f "$CRON_DIR/root" ]; then
    echo "Creating $CRON_DIR/root file and adding the cron line."
    echo "$CRON_LINE" > "$CRON_DIR/root"
else
    # Check if the line is already in the "root" file
    if ! grep -q "$CRON_LINE" "$CRON_DIR/root"; then
        echo "Adding the cron line to $CRON_DIR/root file."
        echo "$CRON_LINE" >> "$CRON_DIR/root"
    else
        echo "$CRON_DIR/root file already contains the cron line."
    fi
fi

# Check if the "user" file exists
if [ ! -f "$CRON_DIR/$USR" ]; then
    echo "Creating $CRON_DIR/$USR file and adding the cron line."
    echo "$CRON_LINE" > "$CRON_DIR/$USR"
else
    # Check if the "user" line is already in the "user" file
    if ! grep -q "$CRON_LINE" "$CRON_DIR/$USR"; then
        echo "Adding the cron line to $CRON_DIR/$USR file."
        echo "$CRON_LINE" >> "$CRON_DIR/$USR"
    else
        echo "$CRON_DIR/$USR file already contains the cron line."
    fi
fi



    # Check synthax of crontab files just created
    crontab -T /var/spool/cron/crontabs/root || handle_error
    crontab -T /var/spool/cron/crontabs/$USR || handle_error
}


run_modeprobed-db() {
   modprobed-db store
}


check_list() {
   modprobed-db list
}


cronie_check() {
   #grep "cronie" /var/log/syslog
   clear;  echo -e "\n\n\n\n\n";
   crontab -l
   echo -e "\n\n\n\n\n"
   systemctl status cronie
}




#Main script execution
root_check

while true; do
clear
echo -e "\n\n\n\n\n\n\n\n\n\n"  # Clear the screen with new lines
echo "                             Please select the options separated by a hyphen (-):"
echo "                               1. Git and build modeprobed-db"
echo "                               2. Create a cron task to scan for kernel modules every hour"
echo "                               3. Execute modeprobed-db"
echo "                               4. check modeprobed-db list"
echo "                               5. Check cronie status and active task"
echo "                               6. Exit"




read -p "                             Enter your choice (e.g., 1-2-4): " choices

IFS='-' read -ra selected_choices <<< "$choices"

for choice in "${selected_choices[@]}"; do
    case $choice in
        1)
            git_build
            ;;
        2)
            cron_task
            ;;
        3)
            run_modeprobed-db
            ;;
        4)
            check_list
            ;;


        5)
            cronie_check
            ;;

        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice: $choice. Skipping."
            ;;
    esac
done
done
