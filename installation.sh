#!/bin/bash
sudo dnf upgrade -y && \
	sudo dnf install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" && \
	sudo dnf update -y && \
	sudo dnf install \
	git \
	i3-gaps dmenu xfce-polkit picom alacritty rofi polybar jgmenu xdotool fontawesome5-* \
	xfce4-power-manager nitrogen lxappearance adwaita-gtk2-theme adwaita-cursor-theme adwaita-blue-gtk-theme \
	akmod-nvidia mangohud xorg-x11-drv-nvidia-cuda nvidia-xconfig \
	flatpak \
	gstreamer1-plugin-openh264 mozilla-openh264 podman \
	gvfs-smb vim \
	steam-devices toolbox gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav \
	--exclude=gstreamer1-plugins-bad-free-devel \
	bluez bluez-tools blueman -y

sudo dnf install xrdp -y && \
	sudo systemctl enable xrdp --now && \
	sudo firewall-cmd --permanent --add-port=3389/tcp && sudo firewall-cmd --reload && \
	sudo chcon --type=bin_t /usr/sbin/xrdp  && sudo chcon --type=bin_t /usr/sbin/xrdp-sesman 

#sudo dnf group install "Fedora Workstation" -y
