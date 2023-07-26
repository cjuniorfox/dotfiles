#!/bin/bash

sudo rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
	rpm-ostree update

sudo wget "https://copr.fedorainfracloud.org/coprs/solopasha/xwayland/repo/fedora-$(rpm -E %fedora)/solopasha-xwayland-fedora-$(rpm -E %fedora).repo" -O /etc/yum.repos.d/solopasha-xwayland-fedora-$(rpm -E %fedora).repo
sudo wget "https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/repo/fedora-$(rpm -E %fedora)/solopasha-hyprland-fedora-$(rpm -E %fedora).repo" -O /etc/yum.repos.d/solopasha-hyprland-fedora-$(rpm -E %fedora).repo

rpm-ostree update && \
	rpm-ostree override replace --experimental xorg-x11-server-Xwayland --from repo='copr:copr.fedorainfracloud.org:solopasha:xwayland'

rpm-ostree override remove firefox-langpacks firefox xdg-desktop-portal-wlr

rpm-ostree install \
	brightnessctl \
	git \
	gvfs-smb \
	hyprland \
	hyprland-contrib \
	hyprland-plugins \
	hyprpaper \
	hyprpicker \
	hyprshot \
	socat \
	polkit-gnome \
	rpmfusion-free-release \
	rpmfusion-nonfree-release \
	vim \
	wob

sudo flatpak remote-delete fedora && \
	sudo flatpak remote-delete fedora-testing && \
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

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
sudo mkdir -p /usr/local/share/fonts/fontawesome6-free-fonts/
sudo mkdir -p /usr/local/share/fonts/fontawesome6-brands-fonts/

sudo cp  /tmp/fontawesome-free-6.4.0-desktop/otfs/Font\ Awesome\ 6\ Free-Regular-400.otf /usr/local/share/fonts/fontawesome6-free-fonts/
sudo cp  /tmp/fontawesome-free-6.4.0-desktop/otfs/Font\ Awesome\ 6\ Free-Solid-900.otf /usr/local/share/fonts/fontawesome6-free-fonts/
sudo cp  /tmp/fontawesome-free-6.4.0-desktop/otfs/Font\ Awesome\ 6\ Brands-Regular-400.otf /usr/local/share/fonts/fontawesome6-brands-fonts/
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
