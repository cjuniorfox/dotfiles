#!/bin/bash
sudo dnf upgrade && \
	sudo dnf install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" && \
	sudo dnf update && \
	sudo dnf install \
	git \
	i3-gaps dmenu rofi xfce-polkit picom alacritty polybar jgmenu xdotool \
	xfce4-power-manager lxappearance adwaita-gtk2-theme adwaita-cursor-theme adwaita-blue-gtk-theme \
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

sudo dnf remove -y volumeicon xfce4-terminal

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y org.flameshot.Flameshot \
	com.valvesoftware.Steam \
	com.visualstudio.code \
	com.getpostman.Postman \
	org.freedesktop.Platform.VulkanLayer.MangoHud

#Playing games with MangoHUD, steamdeck and so on: https://www.clubedohardware.com.br/forums/topic/1609909-configurando-a-steam-flatpak-discos-mangohud-gamemode-e-remote-play/

#sudo dnf group install "Fedora Workstation"

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
        lock && systemctl suspend
        ;;
    hibernate)
        lock && systemctl hibernate
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

