#!/bin/bash
sudo dnf upgrade && \
	sudo dnf install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" && \
	sudo dnf update && \
	sudo dnf install \
	git \
	i3-gaps dmenu rofi xfce-polkit picom kitty polybar jgmenu xdotool\
	xfce4-power-manager xfce4-settings lxappearance adwaita-gtk2-theme adwaita-cursor-theme adwaita-blue-gtk-theme \
	akmod-nvidia mangohud xorg-x11-drv-nvidia-cuda nvidia-xconfig \
	flatpak \
	mozilla-openh264 \
	toolbox \
	gvfs-smb vim \
	steam-devices \
	toolbox \
	gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav \
	--exclude=gstreamer1-plugins-bad-free-devel \
	blueman \
	gamemode

sudo dnf install xrdp -y && \
	sudo systemctl enable xrdp --now && \
	sudo firewall-cmd --permanent --add-port=3389/tcp && sudo firewall-cmd --reload && \
	sudo chcon --type=bin_t /usr/sbin/xrdp  && sudo chcon --type=bin_t /usr/sbin/xrdp-sesman 

sudo dnf remove -y volumeicon xfce4-terminal firefox

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
	org.mozilla.Firefox
	org.flameshot.Flameshot \
	com.valvesoftware.Steam \
	com.valvesoftware.Steam.CompatibilityTool.Boxtron \
	com.valvesoftware.Steam.Utility.protontricks \
	com.valvesoftware.Steam.Utility.gamescope \
	com.valvesoftware.SteamLinki \
	org.freedesktop.Platform.VulkanLayer.vkBasalt \
       	com.valvesoftware.Steam.Utility.gamescope \
	com.heroicgameslauncher.hgl \
	com.visualstudio.code \
	com.getpostman.Postman \
	org.freedesktop.Platform.VulkanLayer.MangoHud \
	org.freedesktop.Platform.GL.nvidia-530-41-03 \
	org.freedesktop.Platform.GL32.nvidia-530-41-03 \
	com.leinardi.gwe \
	org.gnome.FileRoller \
	com.github.tchx84.Flatseal \
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

wget "https://use.fontawesome.com/releases/v6.4.0/fontawesome-free-6.4.0-desktop.zip" -O /tmp/fontawesome-free-6.4.0-desktop.zip
unzip /tmp/fontawesome-free-6.4.0-desktop.zip -d /tmp/
sudo mkdir /usr/share/fonts/fontawesome6-free-fonts/
sudo mkdir /usr/share/fonts/fontawesome6-brands-fonts/

sudo cp  /tmp/fontawesome-free-6.4.0-desktop/otfs/Font\ Awesome\ 6\ Free-Regular-400.otf /usr/share/fonts/fontawesome6-free-fonts/
sudo cp  /tmp/fontawesome-free-6.4.0-desktop/otfs/Font\ Awesome\ 6\ Free-Solid-900.otf /usr/share/fonts/fontawesome6-free-fonts/
sudo cp  /tmp/fontawesome-free-6.4.0-desktop/otfs/Font\ Awesome\ 6\ Brands-Regular-400.otf /usr/share/fonts/fontawesome6-brands-fonts/
rm -rf /tmp/fontawesome*
cat << EOF | sudo tee /usr/local/bin/i3exit && sudo chmod +x /usr/local/bin/i3exit
#!/bin/sh
#https://www.vivaolinux.com.br/topico/Funtoo/Logout-Suspend-Reboot-e-Shutdown-no-i3wm
lock() {
    i3lock
}
case "\$1" in
    lock)
        lock
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        systemctl suspend
        ;;
    hibernate)
        systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: \$0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac
exit 0
EOF
cat << EOF | sudo tee /usr/local/bin/code && sudo chmod +x /usr/local/bin/code
#!/bin/bash
flatpak run com.visualstudio.code \$1 \$2 \$3 \$4 \$5
EOF

echo Setting\ up\ plymout\ to\ work\ with\ NVidia\ Drivers

sudo ausearch -c 'plymouthd' --raw | audit2allow -M my-plymouthd
sudo semodule -X 300 -i my-plymouthd.pp

echo fallback\ internal\ clock\ to\ RTC
sudo timedatectl set-local-rtc false

