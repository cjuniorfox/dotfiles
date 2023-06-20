#!/bin/bash

echo Installing\ the\ virtualization
sudo dnf groupinstall virtualization
UUID="$(sudo blkid | grep bcache0 | awk -F UUID= '{print $2}' | awk '{print $1}'| sed 's/\"//g')"
echo Writing\ fstab

if [ -z "$(cat /etc/fstab | grep /var/lib/libvirt/images)" ]; then
	cat << EOF | sudo tee -a /etc/fstab
UUID=$UUID /var/lib/libvirt/images btrfs   subvol=libvirt/images,compress=zstd:1 0 0
EOF
fi;

echo Creating\ network\ bridge\ device

nmcli connection add type bridge ifname br0 con-name Bridged\ Network\ \(br0\)
nmcli connection add type bridge-slave ifname enp6s0 master br0 con-name Wired\ Bridged\ \(br0\)
nmcli connection down Wired\ connection\ 1
nmcli connection up Bridged\ Network\ \(br0\)
nmcli connection show --active

echo Enabling\ WoL
nmcli con modify Wired\ Bridged\ \(br0\) 802-3-ethernet.wake-on-lan magic
nmcli c show Wired\ Bridged\ \(br0\) | grep 802-3-ethernet.wake-on-lan

#Fix for virt-manager losing connection after while
#https://discussion.fedoraproject.org/t/virtual-machine-manager-showing-qemu-kvm-connecting/83961/5

sudo tee /etc/sysconfig/virtnetworkd << EOF > /dev/null
VIRTNETWORKD_ARGS=
EOF
sudo systemctl enable virtnetworkd.service --now
