#!/bin/bash

# benchmarks.sh
# Date modified: 2025-05-19

# TODO reuse uninstall script from superposition to add uninstall option.

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
    /home/$USR/Downloads/Unigine_Heaven-4.0.run || handle_error
    sudo mkdir $UNIGINE_PATH
    sudo mv /home/$USR/Unigine_Heaven-4.0 $UNIGINE_PATH
    sudo mkdir /home/$USR/.local/share/applications
    # Create icon - launcher in  ~/.local/share/applications
    # Create the startup file shortcut & icon
    unigine_heaven="/home/jack/.local/share/applications/heaven.desktop"
cat << EOF > "$unigine_heaven"
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Heaven
Comment=DX11 Benchmark
Exec=/home/jack/.local/share/Unigine/Unigine_Heaven-4.0/heaven
Icon=/home/jack/.local/share/Unigine/Unigine_Heaven-4.0/data/launcher/icon.png
Terminal=false
Categories=Game;Benchmark;
EOF
    # Edit launch script path to reflect the folder move...
sed -i 's/cd .\/bin/cd \/home\/jack\/.local\/share\/Unigine\/Unigine_Heaven-4.0\/bin/1' /home/jack/.local/share/Unigine/Unigine_Heaven-4.0/heaven
    #sudo nano /home/jack/.local/share/Unigine/Unigine_Heaven-4.0/heaven
    # Reboot to have icon added into gnome ???
    #sudo cp -i /home/jack/.local/share/Unigine/Unigine_Heaven-4.0/heaven.desktop ~/.local/share/applications
    #mkdir $BENCHMARKS_PATH
    #cd $BENCHMARKS_PATH
    #rm -f /home/$USR/Downloads/Unigine_Heaven-4.0.run
}


unigine_valley() {
   	
    	wget -P /home/$USR/Downloads https://assets.unigine.com/d/Unigine_Valley-1.0.run
   	chmod a+x /home/$USR/Downloads/Unigine_Valley-1.0.run
	/home/$USR/Downloads/Unigine_Valley-1.0.run || handle_error
  	sudo mkdir $UNIGINE_PATH
  	sudo mv /home/$USR/Unigine_Valley-1.0 $UNIGINE_PATH
   	sudo mkdir ~/.local/share/applications
    	# Create icon - launcher in  ~/.local/share/applications
	# Create the startup file shortcut & icon
        unigine_valley="/home/$USR/.local/share/applications/valley.desktop"
 cat << EOF > "$unigine_valley"
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Valley
Comment=DX11 Benchmark
Exec=/home/jack/.local/share/Unigine/Unigine_Valley-1.0/valley
Icon=/home/jack/.local/share/Unigine/Unigine_Valley-1.0/data/launcher/icon.png
Terminal=false
EOF

	# Edit launch script path to reflect the folder move...
sed -i 's/cd .\/bin/cd \/home\/jack\/.local\/share\/Unigine\/Unigine_Valley-1.0\/bin/1' /home/jack/.local/share/Unigine/Unigine_Valley-1.0/valley
	#sudo nano /home/jack/.local/share/Unigine/Unigine_Heaven-4.0/heaven
  
 	#rm -f /home/$USR/Downloads/Unigine_Valley-1.0.run
}



geekbench() 
        GEEKBENCH_PATH="/home/$USR/.local/share/Geekbench"
  	sudo mkdir $GEEKBENCH_PATH
   	wget -P /home/$USR/Downloads https://cdn.geekbench.com/Geekbench-6.4.0-Linux.tar.gz
    	tar -xvf /home/$USR/Downloads/Geekbench-6.4.0-Linux.tar.gz
   	#mkdir $BENCHMARKS_PATH
    	mv /home/$USR/Downloads/Geekbench-6.4.0-Linux $GEEKBENCH_PATH
 	#rm -f /home/$USR/Downloads/Geekbench-6.4.0-Linux.tar.gz
}







# Main script execution
root_check
timer_start
unigine_heaven
#unigine_valley
geekbench
timer_stop
