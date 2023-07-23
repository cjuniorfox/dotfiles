#!/bin/bash

sudo dnf install steam-devices

flatpak install -y \
	com.valvesoftware.Steam \
        com.valvesoftware.Steam.CompatibilityTool.Boxtron \
        com.valvesoftware.Steam.Utility.protontricks \
        com.valvesoftware.Steam.Utility.gamescope \
        com.valvesoftware.SteamLink \
        org.freedesktop.Platform.VulkanLayer.vkBasalt \
        com.heroicgameslauncher.hgl \
	org.freedesktop.Platform.VulkanLayer.MangoHud \
	org.openrgb.OpenRGB

#Steam: https://steamcommunity.com/sharedfiles/filedetails/?id=2615011323
#https://diolinux.com.br/aplicativos/instalar-o-openrgb.html
#Playing games with MangoHUD, steamdeck and so on: https://www.clubedohardware.com.br/forums/topic/1609909-configurando-a-steam-flatpak-discos-mangohud-gamemode-e-remote-play/

#sudo dnf group install "Fedora Workstation"

#Load modules for RGB
cat << EOF | sudo tee /etc/modules-load.d/i2c.conf
i2c-dev
i2c-piix4
EOF

wget "https://openrgb.org/releases/release_0.8/60-openrgb.rules"
mv 60-openrgb.rules /usr/lib/udev/rules.d/60-openrgb.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
