#!/bin/bash

# https://askubuntu.com/questions/1295293/installing-32-bit-libnvidia-gl-alongside-64-bit-version

USR=$(logname)
NV_VER="570.133.07"  # Default Nvidia Driver version
driver_dir="/home/$USR/debian/hw-install/NVIDIA-drivers-archives"
mkdir $driver_dir
driver_file="NVIDIA-Linux-x86_64-${NV_VER}.run"
driver_path="$driver_dir/$driver_file"


cd $driver_dir
wget "https://us.download.nvidia.com/XFree86/Linux-x86_64/${NV_VER}/${driver_file}" -P "$driver_dir"
chmod +x "$driver_path"
sh "$driver_path" -x
cd NVIDIA-Linux-x86_64-$NV_VER/32
sudo mkdir /usr/lib/nvidia/32
sudo cp libEGL* libGLESv* libGLX* libnvidia-egl* libnvidia-gl* libnvidia-tls* /usr/lib/nvidia/32


# There are some symlinks that should be created (update version numbers as appropriate) (this step might not be necessary?):

cd /usr/lib/nvidia/32
sudo ln -s libEGL_nvidia.so.$NV_VER libEGL_nvidia.so.0
sudo ln -s libGLESv1_CM_nvidia.so.$NV_VER libGLESv1_CM_nvidia.so.1
sudo ln -s libGLESv2_nvidia.so.$NV_VER libGLESv2_nvidia.so.2
sudo ln -s libGLX_nvidia.so.$NV_VER libGLX_indirect.so.0
sudo ln -s libGLX_nvidia.so.$NV_VER libGLX_nvidia.so.0

#If your /usr/lib32 is not checked for libraries, create the file /etc/ld.so.conf.d/nvidia32.conf with the content:
sudo touch  /etc/ld.so.conf.d/nvidia32.conf
sudo echo " /usr/lib/nvidia/32" >> /etc/ld.so.conf.d/nvidia32.conf

# Probably need to run this for the system to detect the new libraries:
sudo ldconfig
