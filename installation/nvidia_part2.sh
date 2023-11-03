#!/usr/bin/bash
NVIDIA_VER="$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | sed 's/\./-/g')"

flatpak install -y \
	org.freedesktop.Platform.GL.nvidia-"$NVIDIA_VER" \
        org.freedesktop.Platform.GL32.nvidia-"$NVIDIA_VER" \
        com.leinardi.gwe

echo Setting\ up\ plymout\ to\ work\ with\ NVidia\ Drivers

ausearch -c 'plymouthd' --raw | audit2allow -M my-plymouthd

echo Setting\ up\ environment\ variables

cat << EOF > /tmp/environment
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
ENABLE_VKBASALT=1
LIBVA_DRIVER_NAME=nvidia
QT_QPA_PLATFORMTHEME="wayland;xcb"
WLR_NO_HARDWARE_CURSORS=1
VKD3D_CONFIG=dxr11,dxr
PROTON_ENABLE_NVAPI=1
PROTON_ENABLE_NGX_UPDATER=1
EOF

for i in GBM_BACKEND __GLX_VENDOR_LIBRARY_NAME ENABLE_VKBASALT LIBVA_DRIVER_NAME QT_QPA_PLATFORMTHEME WLR_NO_HARDWARE_CURSORS VKD3D_CONFIG PROTON_ENABLE_NVAPI PROTON_ENABLE_NGX_UPDATER; do
	[[ -z ${!i} ]] && cat /tmp/environment | grep $i >> /etc/environment
done
echo "Please restart your computer"
