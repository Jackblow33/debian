#!/usr/bin/env python3
# Python menu attempt
# menu.py

# Might be needed: sudo apt-get install software-properties-common

import tkinter as tk
from tkinter import ttk
import subprocess

def install_software():
    # Replace the script_path with the path to your bash script
    script_path = "/home/jack/Downloads/hello.sh"
    subprocess.run(["bash", script_path], check=True)

root = tk.Tk()
root.title("Software Installer")

# Create a button to trigger the install script
install_button = ttk.Button(root, text="Install Software", command=install_software)
install_button.pack(pady=20)

root.mainloop()
