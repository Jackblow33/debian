#!/usr/bin/env python3
# Python menu attempt
# menu.py

import tkinter as tk
from tkinter import ttk, messagebox
import subprocess

def run_command(command):
    try:
        subprocess.run(command, check=True)
        messagebox.showinfo("Success", f"Command '{' '.join(command)}' executed successfully.")
    except subprocess.CalledProcessError as e:
        messagebox.showerror("Error", f"Command '{' '.join(command)}' failed with error: {e}")

def apply_gnome_settings():
    # Replace with actual commands to apply GNOME settings
    run_command(["gsettings", "set", "org.gnome.desktop.interface", "gtk-theme", "YourThemeName"])

def install_brave():
    # Use the shell script to install Brave
    script_path = "/home/jack/Downloads/post-install/brave.sh"
    run_command(["bash", script_path])

def install_qemu_kvm():
    run_command(["sudo", "apt", "install", "-y", "qemu-kvm", "libvirt-daemon-system", "libvirt-clients", "bridge-utils"])

def install_benchmarking_tools():
    run_command(["sudo", "apt", "install", "-y", "sysbench", "fio", "ioping"])

def install_steam():
    run_command(["sudo", "apt", "install", "-y", "steam"])

def compile_ge_proton():
    # Replace with actual commands to compile and install GE Proton
    run_command(["git", "clone", "https://github.com/GloriousEggroll/proton-ge-custom.git"])
    run_command(["cd", "proton-ge-custom", "&&", "bash", "build.sh"])

def install_unigine_heaven():
    run_command(["sudo", "apt", "install", "-y", "unigine-heaven"])

def install_unigine_superposition():
    run_command(["sudo", "apt", "install", "-y", "unigine-superposition"])

def install_unigine_valley():
    run_command(["sudo", "apt", "install", "-y", "unigine-valley"])

def install_geekbench():
    run_command(["wget", "https://cdn.geekbench.com/Geekbench-5.4.1-Linux.tar.gz", "-O", "geekbench.tar.gz"])
    run_command(["tar", "-xzf", "geekbench.tar.gz"])
    run_command(["./geekbench5"])

def install_software(software):
    if software == "gnome_settings":
        apply_gnome_settings()
    elif software == "brave":
        install_brave()
    elif software == "qemu_kvm":
        install_qemu_kvm()
    elif software == "benchmarking_tools":
        install_benchmarking_tools()
    elif software == "steam":
        install_steam()
    elif software == "ge_proton":
        compile_ge_proton()
    elif software == "unigine_heaven":
        install_unigine_heaven()
    elif software == "unigine_superposition":
        install_unigine_superposition()
    elif software == "unigine_valley":
        install_unigine_valley()
    elif software == "geekbench":
        install_geekbench()

def create_submenu(parent, title, software_list):
    submenu = ttk.LabelFrame(parent, text=title)
    submenu.pack(padx=10, pady=10, fill="both", expand=True)
    for software in software_list:
        button = ttk.Button(submenu, text=software, command=lambda s=software: install_software(s))
        button.pack(pady=5)

root = tk.Tk()
root.title("Software Installer")

# Create main buttons
ttk.Button(root, text="Apply GNOME Custom Settings", command=lambda: install_software("gnome_settings")).pack(pady=10)

# Create web browser submenu
install_brave = ["Install Brave"]
create_submenu(root, "Web browser", install_brave)

# Create virtualisation submenu
install_qemu_kvm = ["Install Virt-manager qemu-kvm"]
create_submenu(root, "Virtualization", install_qemu_kvm)

# Create benchmarking tools submenu
benchmarking_tools = ["Install Unigine Heaven", "Install Unigine Superposition", "Install Unigine Valley", "Install Geekbench"]
create_submenu(root, "Benchmarking Tools", benchmarking_tools)

# Create gaming apps submenu
gaming_apps = ["Install Steam", "Compile and Install Latest GE Proton"]
create_submenu(root, "Gaming Apps", gaming_apps)

# Start the main event loop
root.mainloop()

