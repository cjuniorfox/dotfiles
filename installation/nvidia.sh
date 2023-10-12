#!/bin/bash

sudo dnf install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" && \
	sudo dnf update && \
	akmod-nvidia xorg-x11-drv-nvidia-cuda nvidia-xconfig

echo "Please, restart your computer, then run part 2."

