#!/bin/bash

USR="logname"

# Function to handle errors
handle_error() {
    echo "Error occurred while setting up cron job. Exiting..."
    exit 1
}

# Create cron task
cron_task() {
    # Install cronie package if not installed
    if ! command -v crontab >/dev/null 2>&1; then
        apt-get update && apt-get install -y cronie
    fi

    # Create log file if it doesn't exist
    LOG_FILE="/var/log/modprobed-db.log"
    if [ ! -f "$LOG_FILE" ]; then
        sudo touch "$LOG_FILE"
        sudo chmod 644 "$LOG_FILE"
    fi

    # Cron directory and line
    CRON_DIR="/var/spool/cron/crontabs"
    CRON_LINE="0 */1 * * * /usr/bin/modprobed-db store >> $LOG_FILE 2>&1 &> /dev/null"

    # Backup existing crontab files
    for file in "root" "$USR"; do
        if [ -f "$CRON_DIR/$file" ]; then
            TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
            cp "$CRON_DIR/$file" "$CRON_DIR/$file.$TIMESTAMP"
            echo "Backed up $CRON_DIR/$file to $CRON_DIR/$file.$TIMESTAMP"
        fi
    done

    # Add cron line to crontab files
    for file in "root" "$USR"; do
        if [ ! -f "$CRON_DIR/$file" ]; then
            echo "Creating $CRON_DIR/$file file and adding the cron line."
            echo "$CRON_LINE" > "$CRON_DIR/$file"
        elif ! grep -q "$CRON_LINE" "$CRON_DIR/$file"; then
            echo "Adding the cron line to $CRON_DIR/$file file."
            echo "$CRON_LINE" >> "$CRON_DIR/$file"
        else
            echo "$CRON_DIR/$file file already contains the cron line."
        fi
    done

    # Check syntax of crontab files
    for file in "root" "$USR"; do
        crontab -T "$CRON_DIR/$file" || handle_error
    done

    echo "Cron job set up successfully."
}

# Call the cron_task function
cron_task
