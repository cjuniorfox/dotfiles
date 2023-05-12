#!/bin/bash
sudo dnf upgrade && \
	sudo dnf install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" && \
	sudo dnf update && \
	sudo dnf install \
	git \
	i3-gaps dmenu xfce-polkit picom alacritty polybar jgmenu xdotool \
	xfce4-power-manager nitrogen lxappearance adwaita-gtk2-theme adwaita-cursor-theme adwaita-blue-gtk-theme \
	akmod-nvidia mangohud xorg-x11-drv-nvidia-cuda nvidia-xconfig \
	flatpak \
	mozilla-openh264 \
	toolbox \
	gvfs-smb vim \
	steam-devices \
	toolbox \
	gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav \
	--exclude=gstreamer1-plugins-bad-free-devel \
	blueman

sudo dnf install xrdp -y && \
	sudo systemctl enable xrdp --now && \
	sudo firewall-cmd --permanent --add-port=3389/tcp && sudo firewall-cmd --reload && \
	sudo chcon --type=bin_t /usr/sbin/xrdp  && sudo chcon --type=bin_t /usr/sbin/xrdp-sesman 

sudo dnf remove volumeicon xfce4-terminal

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install org.flameshot.Flameshot com.valvesoftware.Steam com.visualstudio.code com.getpostman.Postman

#sudo dnf group install "Fedora Workstation"

wget "https://use.fontawesome.com/releases/v6.4.0/fontawesome-free-6.4.0-desktop.zip" -O /tmp/fontawesome-free-6.4.0-desktop.zip
unzip /tmp/fontawesome-free-6.4.0-desktop.zip -d /tmp/
sudo mkdir /usr/share/fonts/fontawesome6-free-fonts/
sudo mkdir /usr/share/fonts/fontawesome6-brands-fonts/

sudo cp  /tmp/fontawesome-free-6.4.0-desktop/otfs/Font\ Awesome\ 6\ Free-Regular-400.otf /usr/share/fonts/fontawesome6-free-fonts/
sudo cp  /tmp/fontawesome-free-6.4.0-desktop/otfs/Font\ Awesome\ 6\ Free-Solid-900.otf /usr/share/fonts/fontawesome6-free-fonts/
sudo cp  /tmp/fontawesome-free-6.4.0-desktop/otfs/Font\ Awesome\ 6\ Brands-Regular-400.otf /usr/share/fonts/fontawesome6-brands-fonts/
