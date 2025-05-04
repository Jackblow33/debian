#!/bin/bash

# Debian sid base gnome desktop environment packages installer (Linux from scratch).

# Set the input file path
USR=$(logname)
input_file="/home/$USR/debian/pkgs-tools/pkgs.list"
start_time=$SECONDS
timestamp=$(date +"%Y-%m-%d-%H-%M")
log_file="/home/$USR/debian/pkgs-tools/installation-$timestamp.log"

if ! whiptail --title "Debian 13 sid Installation" --yesno "You are about to install Debian 13 sid packages. Would you like to proceed?" 8 60; then
    echo "Installation cancelled."
    exit 1
fi

# Gather system information
os_info=$(lsb_release -d | awk -F':' '{print $2}' | tr -d ' ')
kernel_info=$(uname -r)
cpu_info=$(lscpu | grep "Model name" | awk -F':' '{print $2}' | tr -d ' ')
mem_info=$(free -h | grep "Mem" | awk '{print $2 " / " $7}')
disk_info=$(df -h / | awk 'NR==2 {print $2 " / " $3}')
net_info=$(ip addr show | grep "state UP" -m 1 | awk '{print $2, $7}' | tr -d "/")
gpu_info=$(lspci | grep -i "VGA" | awk -F':' '{print $3}' | tr -d ' ')

# Install the packages and log the output
echo "System Information:" | tee -a "$log_file"
echo "OS: $os_info" | tee -a "$log_file"
echo "Kernel: $kernel_info" | tee -a "$log_file"
echo "CPU: $cpu_info" | tee -a "$log_file"
echo "Memory: $mem_info" | tee -a "$log_file"
echo "Disk: $disk_info" | tee -a "$log_file"
echo "Network: $net_info" | tee -a "$log_file"
echo "GPU: $gpu_info" | tee -a "$log_file"
echo "Installing packages. This may take a while, please wait..." | tee -a "$log_file"
sudo apt-get install -y $(cat "$input_file") 2>&1 | tee -a "$log_file"

end_time=$SECONDS
elapsed_time=$((end_time - start_time))
elapsed_minutes=$((elapsed_time / 60))
elapsed_seconds=$((elapsed_time % 60))

total_time_message="Total time elapsed: $elapsed_minutes minutes and $elapsed_seconds seconds."
reboot_message="The packages have been installed successfully. A reboot is required to complete the installation. Press Enter to reboot the system."

echo -e "\n$total_time_message" | tee -a "$log_file"

whiptail --title "Installation Complete" --msgbox "$total_time_message\n\nInstallation log saved to: $log_file\n\n$reboot_message" 14 80

read -p "" 

sudo reboot
