#!/usr/bin/env bash

set -euo pipefail

echo "Refreshing system and installing base groups..."
dnf update --refresh -y

dnf group install -y \
	admin-tools \
	core \
	fonts \
	hardware-support \
	multimedia \
	standard

echo "Installing base packages..."
dnf install -y \
  adwaita-gtk2-theme \
  adwaita-icon-theme \
  azote \
  bash-completion \
  blueman \
  breeze-cursor-theme \
  breeze-gtk \
  breeze-icon-theme \
  chrony \
  dunst \
  firewall-config \
  flatpak \
  fontawesome-fonts-all \
  git \
  gnome-keyring \
  gnome-packagekit \
  gnome-software \
  gvfs-smb \
  gvfs-nfs \
  htop \
  hyprland \
  ibus \
  kernel-modules-extra \
  kitty \
  liberation-fonts \
  nautilus \
  network-manager-applet \
  pavucontrol \
  pulseaudio-utils \
  sddm \
  seahorse \
  socat \
  system-config-printer \
  xdg-user-dirs \
  xdg-user-dirs-gtk \
  wlr-randr

# Remove unnecessary package (optional, but may no longer exist)
# dnf remove -y imsettings

echo "Enabling COPR repo: solopasha/hyprland"
dnf copr enable -y solopasha/hyprland
dnf update --refresh -y
dnf install -y \
  cliphist \
  hyprshot \
  wl-clipboard

echo "Enabling COPR repo: cjuniorfox/hyprland-shell"
dnf copr enable -y cjuniorfox/hyprland-shell
dnf update --refresh -y
dnf install -y \
  checkupdate \
  hyprland-shell-config \
  wol-changer

echo "Switching rofi to rofi-wayland..."
dnf swap -y rofi rofi-wayland

systemctl enable --now checkupdate.timer
systemctl enable --now chronyd

echo "Enabling COPR repo: tofik/sway"
dnf copr enable -y tofik/sway
dnf update --refresh -y
dnf install -y sway-audio-idle-inhibit

echo "Configuring Flatpak..."
flatpak remote-delete -y fedora || true
flatpak remote-delete -y fedora-testing || true
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
  com.github.tchx84.Flatseal \
  org.gnome.Calculator \
  org.gnome.Evince \
  org.gnome.FileRoller \
  org.gnome.FontManager \
  org.gnome.Loupe \
  org.gnome.TextEditor \
  org.mozilla.firefox \
  org.freedesktop.Platform.ffmpeg-full/x86_64/22.08 \
  org.freedesktop.Platform.openh264/x86_64/2.3.1

echo "Setting Plymouth theme..."
plymouth-set-default-theme bgrt -R

echo "Setting graphical target as default..."
systemctl set-default graphical.target

