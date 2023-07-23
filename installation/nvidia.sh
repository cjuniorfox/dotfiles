#!/bin/bash

sudo dnf install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" && \
	sudo dnf update && \
	akmod-nvidia xorg-x11-drv-nvidia-cuda nvidia-xconfig

NVIDIA_VER="$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | sed 's/\./-/g')"

flatpak install -y \
	org.freedesktop.Platform.GL.nvidia-"$NVIDIA_VER" \
        org.freedesktop.Platform.GL32.nvidia-"$NVIDIA_VER" \
        com.leinardi.gwe

echo Setting\ up\ plymout\ to\ work\ with\ NVidia\ Drivers

sudo ausearch -c 'plymouthd' --raw | audit2allow -M my-plymouthd
sudo semodule -X 300 -i my-plymouthd.pp
