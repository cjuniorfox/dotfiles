NVIDIA=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader --id=0 | sed 's/\./-/g')
flatpak install  \
com.heroicgameslauncher.hgl \
com.valvesoftware.Steam \
com.valvesoftware.Steam.CompatibilityTool.Boxtron \
com.valvesoftware.SteamLink \
net.davidotek.pupgui2 \
org.freedesktop.Platform.GL.nvidia-${NVIDIA} \
org.freedesktop.Platform.GL32.nvidia-${NVIDIA} \
org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08 \
org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08 \
org.winehq.Wine.DLLs.dxvk/x86_64/stable-23.08 \
org.winehq.Wine.gecko/x86_64/stable-23.08 \
org.winehq.Wine.mono/x86_64/stable-23.08 \
org.yuzu_emu.yuzu


