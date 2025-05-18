#!/bin/bash

# benchmarks.sh
# Date modified: 2025-05-18

TIMESTAMP=$(date +%Y%m%d.%R)
USR=$(logname)
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'  # No color
BENCHMARKS_PATH="/home/$USR/Benchmarks"
UNIGINE_PATH="/home/$USR/.local/share/Unigine"

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
	wget -P /home/$USR/Downloads https://assets.unigine.com/d/Unigine_Heaven-4.0.run
	chmod +x /home/$USR/Downloads/Unigine_Heaven-4.0.run
 	sudo mkdir $UNIGINE_PATH
  	sudo mv /home/$USR/Unigine_Heaven-4.0 $UNIGINE_PATH
   	sudo mkdir ~/.local/share/applications
    	# Create icon - launcher in  ~/.local/share/applications
	# Create the startup file shortcut & icon
	USR=$(logname)
        unigine_heaven="/home/$USR/.config/autostart/heaven.desktop"
 	cat << EOF > "$heaven.desktop"
	[Desktop Entry]
	Type=Application
	Encoding=UTF-8
	Name=Heaven
	Comment=DX11 Benchmark
	Exec=/home/jack/.local/share/Unigine/Unigine_Heaven-4.0/heaven
	Icon=/home/jack/.local/share/Unigine/Unigine_Heaven-4.0/48_icon.png
	Terminal=false
	EOF
 	# Then edit launch script path to reflect the folder move...
  	sed -i 's/cd .\/bin/cd \/home\/jack\/.local\/share\/Unigine\/Unigine_Heaven-4.0\/bin/1' /home/jack/.local/share/Unigine/Unigine_Heaven-4.0/heaven
	#sudo nano /home/jack/.local/share/Unigine/Unigine_Heaven-4.0/heaven
 	# Reboot to have icon added into gnome ???
     
     	#sudo cp -i /home/jack/.local/share/Unigine/Unigine_Heaven-4.0/heaven.desktop ~/.local/share/applications
	#mkdir $BENCHMARKS_PATH
	#cd $BENCHMARKS_PATH
	/home/$USR/Downloads/Unigine_Heaven-4.0.run || handle_error
	#rm -f /home/$USR/Downloads/Unigine_Heaven-4.0.run
}



unigine_superposition() {
    	wget -P /home/$USR/Downloads https://assets.unigine.com/d/Unigine_Superposition-1.1.run
    	chmod a+x /home/$USR/Downloads/Unigine_Superposition-1.1.run
	#mkdir $BENCHMARKS_PATH
	#cd $BENCHMARKS_PATH
	#/home/$USR/Downloads/Unigine_Superposition-1.1.run || handle_error
 	#rm -f /home/$USR/Downloads/Unigine_Superposition-1.1.run
}



unigine_valley() {
   	wget -P /home/$USR/Downloads https://assets.unigine.com/d/Unigine_Valley-1.0.run
   	chmod a+x /home/$USR/Downloads/Unigine_Valley-1.0.run
   	#mkdir $BENCHMARKS_PATH
	#cd $BENCHMARKS_PATH
	#/home/$USR/Downloads/Unigine_Valley-1.0.run || handle_error
 	#rm -f /home/$USR/Downloads/Unigine_Valley-1.0.run
}



geekbench() 
   	wget -P /home/$USR/Downloads https://cdn.geekbench.com/Geekbench-6.4.0-Linux.tar.gz
    	tar -xvf /home/$USR/Downloads/Geekbench-6.4.0-Linux.tar.gz
   	#mkdir $BENCHMARKS_PATH
    	mv /home/$USR/Downloads/Geekbench-6.4.0-Linux $BENCHMARKS_PATH
	#cd $BENCHMARKS_PATH
 	#rm -f /home/$USR/Downloads/Geekbench-6.4.0-Linux.tar.gz
}







# Main script execution
root_check
timer_start
unigine_heaven
#unigine_superposition
unigine_valley
geekbench
timer_stop
