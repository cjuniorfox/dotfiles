#!/bin/bash

echo "Make sure you're added the local repo alongside build the packages i3exit, checkupdate and fontawesome6"

sudo wget "https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/repo/fedora-$(rpm -E %fedora)/solopasha-hyprland-fedora-$(rpm -E %fedora).repo" -O /etc/yum.repos.d/solopasha-hyprland-fedora-$(rpm -E %fedora).repo

rpm-ostree override replace --experimental xorg-x11-server-Xwayland --from repo='copr:copr.fedorainfracloud.org:solopasha:hyprland'

rpm-ostree override remove firefox-langpacks firefox xdg-desktop-portal-wlr

rpm-ostree install \
	azote \
	brightnessctl \
	git \
	gvfs-smb \
	hyprland \
	hyprland-contrib \
	hyprland-plugins \
	hyprpaper \
	hyprpicker \
	hyprshot \
	i3exit \
	socat \
	polkit-gnome \
	rpmfusion-free-release \
	rpmfusion-nonfree-release \
	vim \
	wlr-randr \
	wob

sudo flatpak remote-delete fedora && \
	sudo flatpak remote-delete fedora-testing && \
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
	com.github.hluk.copyq \
	com.github.tchx84.Flatseal \
	org.gnome.Calculator \
	org.gnome.FileRoller \
	org.gnome.FontManager \
	org.mozilla.firefox \
	org.freedesktop.Platform.ffmpeg-full \
	org.freedesktop.Platform.openh264
