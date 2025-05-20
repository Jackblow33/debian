#!/bin/bash

# Remove installed debian proprietary driver packages .deb
# https://www.reddit.com/r/debian/comments/16q9ok0/trying_to_purge_nvidia/?rdt=62828


# Remove (add purge) 99% of the nvidia packages

  sudo apt-get remove --purge nvidia-installer-cleanup \
  nvidia-persistenced

# Remove (and purge) the auto-installed nvidia stuff

  sudo apt-get autoremove --purge
