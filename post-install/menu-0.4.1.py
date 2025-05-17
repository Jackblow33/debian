#!/usr/bin/env python3
# Python menu attempt
# menu-0.4.1.py

import tkinter as tk
from tkinter import ttk, messagebox
import subprocess
import os

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

def load_at_boot():
    if boot_checkbox.get():
        # Check if the script is already in the startup applications
        startup_file = os.path.expanduser("~/.config/autostart/software_installer.desktop")
        autostart_dir = os.path.dirname(startup_file)
        if not os.path.exists(autostart_dir):
            os.makedirs(autostart_dir)
        if not os.path.exists(startup_file):
            # Create the startup file
            with open(startup_file, "w") as f:
                f.write("[Desktop Entry]\n")
                f.write("Name=Software Installer\n")
                f.write("Exec=python3 /home/jack/Downloads/post-install/menu-0.4.1.py\n")
                f.write("Terminal=false\n")
                f.write("Type=Application\n")
                f.write("Hidden=false\n")
        messagebox.showinfo("Success", "Software Installer will now load at boot.")
    else:
        # Remove the startup file
        startup_file = os.path.expanduser("~/.config/autostart/software_installer.desktop")
        if os.path.exists(startup_file):
            os.remove(startup_file)
        messagebox.showinfo("Success", "Software Installer will no longer load at boot.")

root = tk.Tk()
root.title("Software Installer")
root.geometry("800x600")

# Create the left side buttons
left_side = ttk.Frame(root)
left_side.pack(side=tk.LEFT, padx=20, pady=20, fill="both", expand=True)

ttk.Button(left_side, text="Apply GNOME Custom Settings", command=lambda: install_software("gnome_settings")).pack(pady=10)

web_browser_submenu = ["Install Brave", "Future option"]
create_submenu(left_side, "Web Browsers", web_browser_submenu)

virtualization_submenu = ["Install Virt-manager qemu-kvm", "Future option"]
create_submenu(left_side, "Virtualization", virtualization_submenu)

# Create the right side buttons
right_side = ttk.Frame(root)
right_side.pack(side=tk.RIGHT, padx=20, pady=20, fill="both", expand=True)

benchmarking_tools = ["Install Unigine Heaven", "Install Unigine Superposition", "Install Unigine Valley", "Install Geekbench"]
create_submenu(right_side, "Benchmarking Tools", benchmarking_tools)

gaming_apps = ["Install Steam", "Compile and Install Latest GE Proton"]
create_submenu(right_side, "Gaming Apps", gaming_apps)

# Add the checkbox to load the script at boot
boot_checkbox = tk.BooleanVar()
boot_checkbox_widget = ttk.Checkbutton(root, text="Load at boot", variable=boot_checkbox, command=load_at_boot)
boot_checkbox_widget.pack(pady=10)

# Start the main event loop
root.mainloop()
