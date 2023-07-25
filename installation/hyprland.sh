sudo dnf upgrade -y && \
	sudo dnf install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" && \
	sudo dnf install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" && \
        sudo dnf copr enable solopasha/hyprland && \
	sudo dnf update -y && \
	sudo dnf remove firefox xdg-desktop-portal-wlr -y && \
	sudo dnf install adwaita-blue-gtk-theme \
	adwaita-gtk2-theme \
	blueman \
	brightnessctl \
	flatpak \
	git \
	gvfs-smb \
	hyprland \
	hyprland-contrib \
	hyprland-plugins \
	hyprpaper \
	hyprpicker \
	hyprshot \
	kitty \
	nautilus \
	network-manager-applet \
	pavucontrol \
	polkit-gnome \
	pulseaudio-utils \
	rofi-wayland \
	rpmfusion-free-release \
	rpmfusion-nonfree-release \
	steam-devices \
	swaybg \
	swayidle \
	swaylock \
	toolbox \
	vim-enhanced \
	waybar-hyprland \
	wlr-randr \
	wob \
	xdg-desktop-portal-hyprland

sudo flatpak remote-delete fedora && \
	sudo flatpak remote-delete fedora-testing && \
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
	com.github.hluk.copyq \
	com.github.tchx84.Flatseal \
	org.gnome.Calculator \
	org.gnome.FileRoller \
	org.gnome.FontManager \
	org.mozilla.firefox \
	org.freedesktop.Platform.ffmpeg-full \
	org.freedesktop.Platform.openh264

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
