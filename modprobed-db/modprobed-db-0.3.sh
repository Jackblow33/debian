#!/bin/bash

# modeprobed-db.sh
# Date modified: 2025-04-27

USR="$(logname)"

# Root_check
root_check() {
    if [ "$EUID" -ne 0 ]; then
        echo "This script must be run as root."
        exit 1
    fi
}

# Function to handle errors
handle_error() {
    echo "Error occurred. Exiting..."
    exit 1
}


press_enter_to_continue() {
    read -p "Press Enter to continue..." -n1 -s
    echo
}



git_build() {
    git clone https://github.com/graysky2/modprobed-db.git /home/$USR/github/modeprobed-db || handle_error
    cd /home/$USR/github/modeprobed-db
    make && make install || handle_error
    modprobed-db --version || handle_error
    echo -e "\033[0;32mmodprobed-db Ready...\033[0m"
    modprobed-db store || handle_error
    echo -e "\033[0;32mDone...\033[0m"
    press_enter_to_continue
}

cron_task() {
    if ! command -v crontab >/dev/null 2>&1; then
        apt-get update && apt-get install -y cronie || handle_error
    fi

    LOG_FILE="/var/log/modprobed-db.log"
    if [ ! -f "$LOG_FILE" ]; then
        sudo touch "$LOG_FILE"
        sudo chmod 644 "$LOG_FILE"
    fi

    CRON_DIR="/var/spool/cron/crontabs"
    CRON_LINE="0 */1 * * * /usr/bin/modprobed-db store >> $LOG_FILE 2>&1 &> /dev/null"
    OLD_CRON_LINE="0 */1 * * *   /usr/bin/modprobed-db store &> /dev/null"

    for file in "root" "$USR"; do
        if [ -f "$CRON_DIR/$file" ]; then
            TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
            cp "$CRON_DIR/$file" "$CRON_DIR/$file.$TIMESTAMP"
            echo "Backed up $CRON_DIR/$file to $CRON_DIR/$file.$TIMESTAMP"
        fi
    done

    for file in "root" "$USR"; do
        if [ ! -f "$CRON_DIR/$file" ]; then
            echo "Creating $CRON_DIR/$file file and adding the cron line."
            echo "$CRON_LINE" > "$CRON_DIR/$file"
        elif ! grep -q "$CRON_LINE" "$CRON_DIR/$file"; then
            if grep -q "$OLD_CRON_LINE" "$CRON_DIR/$file"; then
                sed -i "/$OLD_CRON_LINE/d" "$CRON_DIR/$file"
                echo "Removed old cron job from $CRON_DIR/$file"
            fi
            echo "Adding the cron line to $CRON_DIR/$file file."
            echo "$CRON_LINE" >> "$CRON_DIR/$file"
        else
            echo "$CRON_DIR/$file file already contains the cron line."
        fi
    done

    for file in "root" "$USR"; do
        crontab -T "$CRON_DIR/$file" || handle_error
    done

    echo "Cron job set up successfully."
}


scan_modeprobed-db() {
   modprobed-db store
   press_enter_to_continue
}


check_list() {
   modprobed-db list
   press_enter_to_continue
}


cronie_check() {
   #grep "cronie" /var/log/syslog
   clear;  echo -e "\n\n\n\n\n";
   crontab -l
   echo -e "\n\n\n\n\n"
   systemctl status cronie
   press_enter_to_continue
}


remove_cron_task() {
    CRON_DIR="/var/spool/cron/crontabs"
    CRON_LINE="0 */1 * * * /usr/bin/modprobed-db store >> /var/log/modprobed-db.log 2>&1 &> /dev/null"

    for file in "root" "$USR"; do
        if [ -f "$CRON_DIR/$file" ]; then
            if grep -q "$CRON_LINE" "$CRON_DIR/$file"; then
                sed -i "/$CRON_LINE/d" "$CRON_DIR/$file"
                echo "Removed cron job from $CRON_DIR/$file"
            else
                echo "Cron job not found in $CRON_DIR/$file"
            fi
        else
            echo "$CRON_DIR/$file does not exist"
        fi
    done
    press_enter_to_continue
}

view_log() {
    LOG_FILE="/var/log/modprobed-db.log"
    if [ -f "$LOG_FILE" ]; then
        echo "Contents of $LOG_FILE:"
        cat "$LOG_FILE"
        press_enter_to_continue
    else
        echo "Log file $LOG_FILE does not exist."
        press_enter_to_continue
    fi
}



# Main script execution

while true; do
    clear
    echo -e "\n\n\n\n\n\n\n\n\n\n"  # Clear the screen with new lines
    echo "                             Please select the options separated by a hyphen (-):"
    echo "                               1. Git and build modeprobed-db"
    echo "                               2. Create a cron task to scan for kernel modules every hour"
    echo "                               3. Manually scan for kernel modules loaded"
    echo "                               4. Check modeprobed-db list"
    echo "                               5. Check cronie status and active task"
    echo "                               6. Remove cron task"
    echo "                               7. View log file"
    echo "                               8. Exit"

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
                scan_modeprobed-db
                ;;
            4)
                check_list
                ;;
            5)
                cronie_check
                ;;
            6)
                remove_cron_task
                ;;
            7)
                view_log
                ;;
            8)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice: $choice. Skipping."
                ;;
        esac
    done
done

