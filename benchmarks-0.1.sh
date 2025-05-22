#!/bin/bash

# benchmarks.sh
# Date modified: 2025-05-21

# TODO reuse uninstall script from superposition to add uninstall option.
# TODO remove jack

TIMESTAMP=$(date +%Y%m%d.%R)
USR=$(logname)
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'  # No color
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
    wget -P /home/$USR/Downloads https://assets.unigine.com/d/Unigine_Heaven-4.0.run || handle_error
    chmod +x /home/$USR/Downloads/Unigine_Heaven-4.0.run || handle_error
    sudo mkdir -p $UNIGINE_PATH || handle_error
    sudo chmod 777 $UNIGINE_PATH || handle_error
    cd $UNIGINE_PATH || handle_error
    /home/$USR/Downloads/Unigine_Heaven-4.0.run || handle_error
    #sudo mv /home/$USR/Unigine_Heaven-4.0 $UNIGINE_PATH
    sudo mkdir -p /home/$USR/.local/share/applications || handle_error
    # Create icon - launcher in  ~/.local/share/applications
    # Create the startup file shortcut & icon
    unigine_heaven="/home/$USR/.local/share/applications/heaven.desktop"
cat << EOF > "$unigine_heaven" || handle_error
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
	sudo chmod 777 "$unigine_heaven"
    	# Edit launch script path to reflect the folder move...
	sed -i 's/cd .\/bin/cd \/home\/jack\/.local\/share\/Unigine\/Unigine_Heaven-4.0\/bin/1' /home/jack/.local/share/Unigine/Unigine_Heaven-4.0/heaven || handle_error
    	# Delete downloaded file
	#sudo rm -f /home/$USR/Downloads/Unigine_Heaven-4.0.run
}


unigine_valley() {
   	
    	wget -P /home/$USR/Downloads https://assets.unigine.com/d/Unigine_Valley-1.0.run || handle_error
   	chmod a+x /home/$USR/Downloads/Unigine_Valley-1.0.run || handle_error
    	sudo mkdir -p $UNIGINE_PATH || handle_error
    	cd $UNIGINE_PATH || handle_error
	/home/$USR/Downloads/Unigine_Valley-1.0.run || handle_error
  	#sudo mv /home/$USR/Unigine_Valley-1.0 $UNIGINE_PATH || handle_error
   	sudo mkdir -p /home/$USR.local/share/applications || handle_error
    	# Create icon - launcher in  ~/.local/share/applications
	# Create the startup file shortcut & icon
        unigine_valley="/home/$USR/.local/share/applications/valley.desktop"
 cat << EOF > "$unigine_valley" || handle_error
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Valley
Comment=DX11 Benchmark
Exec=/home/jack/.local/share/Unigine/Unigine_Valley-1.0/valley
Icon=/home/jack/.local/share/Unigine/Unigine_Valley-1.0/data/launcher/icon.png
Terminal=false
EOF
	sudo chmod 777 "$unigine_valley"
	# Edit launch script path to reflect the folder move...
	sed -i 's/cd .\/bin/cd \/home\/jack\/.local\/share\/Unigine\/Unigine_Valley-1.0\/bin/1' /home/jack/.local/share/Unigine/Unigine_Valley-1.0/valley || handle_error
	# Delete downloaded file
	#rm -f /home/$USR/Downloads/Unigine_Valley-1.0.run
}



geekbench() {
    GEEKBENCH_PATH="/home/$USR/.local/share/Geekbench"
    sudo mkdir -p $GEEKBENCH_PATH || handle_error
    wget -P /home/$USR/Downloads https://cdn.geekbench.com/Geekbench-6.4.0-Linux.tar.gz || handle_error
    tar -xvf /home/$USR/Downloads/Geekbench-6.4.0-Linux.tar.gz -C /home/$USR/Downloads || handle_error
    mv /home/$USR/Downloads/Geekbench-6.4.0-Linux $GEEKBENCH_PATH || handle_error
    cp /home/$USR/debian/icons/geekbench_6-icon.png /home/$USR/.local/share/Geekbench/Geekbench-6.4.0-Linux || handle_error
    # rm -f /home/$USR/Downloads/Geekbench-6.4.0-Linux.tar.gz
    geekbench_6="/home/$USR/.local/share/applications/geekbench6.desktop"
 cat << EOF > "$geekbench_6" || handle_error
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Geekbench 6
Comment=Benchmark
Exec=/home/jack/.local/share/Geekbench/Geekbench-6.4.0-Linux/geekbench6
Icon=/home/jack/.local/share/Geekbench/Geekbench-6.4.0-Linux/geekbench_6-icon.png
Terminal=true
EOF
sudo chmod 777 "$geekbench_6"
}






# Main script execution
root_check
timer_start
unigine_heaven
#unigine_valley
#geekbench
timer_stop

# TODO
## uninstall Superposition.desktop, icons and current dir
#read -p "UNIGINE Superposition Benchmark will be completely removed, do you want to continue? [Y/n]: " ans_yn
#	case "$ans_yn" in
#		[Yy]|[Yy][Ee][Ss])
#			echo "Removing..."
#			INSTALL_DIR="$(dirname "$(readlink -f "$0")")"
#			rm -f ~/.local/share/applications/Superposition.desktop
#			rm -f ~/Desktop/Superposition.desktop
#			rm -f ~/.local/share/icons/Superposition.png
#			for RES in 16 24 32 48 64 128 256
#			do
#				rm -f ~/.local/share/icons/hicolor/"$RES"x"$RES"/apps/Superposition.png
#			done
#			cd $INSTALL_DIR/../
#			rm -rf $INSTALL_DIR;;
#		*)
#			echo "Abort"
#			exit 3;;
#	esac
#
