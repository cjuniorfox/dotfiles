#!/bin/bash

dnf install -y steam-devices gamescope

flatpak install -y \
	com.valvesoftware.Steam \
        com.valvesoftware.Steam.CompatibilityTool.Boxtron \
        com.valvesoftware.Steam.Utility.protontricks \
        org.freedesktop.Platform.VulkanLayer.gamescope \
        com.valvesoftware.SteamLink \
        org.freedesktop.Platform.VulkanLayer.vkBasalt \
	net.davidotek.pupgui2 \
        com.heroicgameslauncher.hgl \
	org.freedesktop.Platform.VulkanLayer.MangoHud

#Steam: https://steamcommunity.com/sharedfiles/filedetails/?id=2615011323
#https://diolinux.com.br/aplicativos/instalar-o-openrgb.html
#Playing games with MangoHUD, steamdeck and so on: https://www.clubedohardware.com.br/forums/topic/1609909-configurando-a-steam-flatpak-discos-mangohud-gamemode-e-remote-play/
