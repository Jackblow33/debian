#!/bin/bash

# local-repo.sh
# 2025-05-06

# Install and setup local repository
USR=$(logname)
repo_path=/home/$USR/Local_Repo  # create home parttion and put
list_dir="/home/$USR/debian/pkgs-tools"
pkgs_list="$list_dir/tasksel_pkgs.list"
sudo mkdir $repo_path
sudo chmod 777 $repo_path

#3. Configure Your Debian System to Use the Local Repository:

#   Edit the sources.list file: Open the sources.list
# sed -i "deb file:///home/user/repo" >> /etc/apt/sources.list.d/sources.list  #Check this one
# sudo sed -i "deb file:$repo_path" >> /etc/apt/sources.list.d/sources.list  #Check this one
    if ! grep -q 'deb file:$repo_path' /etc/apt/sources.list.d/sources.list ; then
        echo 'deb file:$repo_path' >> /etc/apt/sources.list.d/sources.list
    else
        echo "configuration already present"
    fi

    sudo apt update
    echo "Sources.list updated"



# Download packages without installing in  /var/cache/apt/archives/
dl_pkgs() {
    #sudo apt install -d -y $(cat "$pkgs_list")
    sudo apt-get install -d -y $(cat "$pkgs_list") || handle_error
    cp /var/cache/apt/archives/*.deb $repo_path || handle_error
    echo "Packages download completed"
    # dpkg xyz option maybe
}



# Install reprepro
    sudo apt install -y reprepro

# Initialize the repository
    sudo reprepro -b $repo_path initdebian

# Sign the repository: For secure APT compatibility, sign the repository using OpenPGP
# Generate a key:
    sudo gpg --gen-key

# Add packages
    sudo reprepro -b $repo_path -y -v dadd $repo_path/*.deb

#3. Configure Your Debian System to Use the Local Repository:

#   Edit the sources.list file: Open the sources.list
#sudo nano /etc/apt/sources.list
#   Add the repository to sources.list Add a line similar to this:
# sed -i "deb file:///home/user/repo" >> /etc/apt/sources.list.d/sources.list  #Check this one
# sudo sed -i "deb file:$repo_path" >> /etc/apt/sources.list.d/sources.list  #Check this one
    if ! grep -q 'deb file:$repo_path' /etc/apt/sources.list.d/sources.list ; then
        echo 'deb file:$repo_path' >> /etc/apt/sources.list.d/sources.list
    else
        echo "configuration already present"
    fi

    sudo apt update
    echo "Installation completed"


# Install !

