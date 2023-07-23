#!/bin/bash
sudo dnf upgrade && \
	sudo dnf update && \
	sudo dnf groupinstall Fonts Administrative\ Tools Hardware\ Support && \
	sudo dnf install \
	git \
	sddm rofi-wayland xfce-polkit picom kitty wob \
	xfce4-settings adwaita-gtk2-theme adwaita-cursor-theme adwaita-blue-gtk-theme \
	flatpak \
	mozilla-openh264 \
	toolbox \
	gvfs-smb nautilus vim \
	toolbox \
	gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav \
	--exclude=gstreamer1-plugins-bad-free-devel \
	blueman

sudo dnf copr enable solopasha/hyprland && \
	sudo dnf install hyprland hyprland-contrib hyprland-plugins hyprpaper hyprshot waybar-hyprland xdg-desktop-portal-hyprland \
	aajohan-comfortaa-fonts swayidle swaylock wlr-randr

#sudo dnf remove -y lightdm volumeicon xfce4-terminal thunar

sudo systemctl enable sddm

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
	com.visualstudio.code \
	com.getpostman.Postman \
	com.github.hluk.copyq \
	org.gnome.FileRoller \
	com.github.tchx84.Flatseal \
	org.openrgb.OpenRGB

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

sudo timedatectl set-local-rtc false
