#!/bin/bash

# benchmarks.sh
# Date modified: 2025-04-26

TIMESTAMP=$(date +%Y%m%d.%R)
USR=$(logname)
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'  # No color
BENCHMARKS_PATH="/home/jack/Benchmarks"

timer_start() {
    BEGIN=$(date +%s)
}

timer_stop() {
    NOW=$(date +%s)
    DIFF=$((NOW - BEGIN))
    MINS=$((DIFF / 60))
    SECS=$((DIFF % 60))
    echo "Time elapsed: $MINS:$(printf %02d $SECS)"
}

# Handle errors
handle_error() {
    echo "Error occurred in the script. Exiting."
    exit 1
}

# Root_check
root_check() {
  if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
  fi
}


unigine_heaven() {
	wget -P /home/jack/Downloads https://assets.unigine.com/d/Unigine_Heaven-4.0.run
	sudo chmod +x /home/jack/Downloads/Unigine_Heaven-4.0.run
	sudo mkdir $BENCHMARKS_PATH
	cd $BENCHMARKS_PATH
	sudo /home/jack/Downloads/Unigine_Heaven-4.0.run
}



item_2() {
    echo "item_2"
}



item_3() {
   echo "item_3"
}




# Main script execution
#root_check
timer_start
unigine_heaven
item_2
item_3
timer_stop
