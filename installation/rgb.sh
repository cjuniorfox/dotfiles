#!/bin/bash

flatpak install -y \
	org.openrgb.OpenRGB

#https://diolinux.com.br/aplicativos/instalar-o-openrgb.html

#Load modules for RGB
cat << EOF | tee /etc/modules-load.d/i2c.conf
i2c-dev
i2c-piix4
EOF

wget "https://openrgb.org/releases/release_0.8/60-openrgb.rules"
mv 60-openrgb.rules /usr/lib/udev/rules.d/60-openrgb.rules
udevadm control --reload-rules && sudo udevadm trigger
