#!/bin/bash

sudo dnf install https://download1.rpmfusion.org/{nonfree/fedora/rpmfusion-nonfree,free/fedora/rpmfusion-free}-release-$(rpm -E %fedora).noarch.rpm &&  sudo dnf update
sudo dnf install broadcom-wl kmod-wl
sudo dnf install bluez bluez-libs bluez-tools bluez-cups bluez-hid2hci bluez-cups

sudo rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo rpm-ostree install broadcom-wl
#kmod-wl could be also needed
