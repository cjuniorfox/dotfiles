dnf copr -y enable cjuniorfox/hyprland-desktop
dnf copr -y enable solopasha/hyprland

dnf groupinstall -y \
	Administration\ Tools \
	Common\ NetworkManager\ Submodules \
	Core \
	Fonts \
	Hardware\ Support \
	Multimedia \
	Input\ Methods \
	Printing\ Support \
	Standard

dnf install -y \
	azote \
	blueman \
	brightnessctl \
	checkupdate \
	dunst \
	flatpak \
	fontawesome6-free \
	git \
	gnome-keyring \
	gnome-software \
	gvfs-smb \
	hyprland \
	hyprland-contrib \
	hyprland-plugins \
	hyprland-shell-waybar \
	hyprpaper \
	hyprpicker \
	hyprshot \
	htop \
	i3exit \
	kitty \
	nautilus \
	network-manager-applet \
	pavucontrol \
        plymouth-theme-spinner \
	pulseaudio-utils \
	rofi-wayland \
	rofi-shutdown-menu \
	sddm \
	seahorse \
	socat \
	swaybg \
	swayidle \
	swaylock \
	polkit-gnome \
	xdg-desktop-portal-hyprland \
	xdg-user-dirs \
	xdg-user-dirs-gtk \
	waybar-hyprland \
	wlr-randr \
	wob

flatpak remote-delete fedora && \
	flatpak remote-delete fedora-testing
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
	com.github.hluk.copyq \
	com.github.tchx84.Flatseal \
	org.gnome.Calculator \
	org.gnome.Evince \
	org.gnome.FileRoller \
	org.gnome.FontManager \
	org.gnome.Loupe \
	org.mozilla.firefox \
	org.freedesktop.Platform.ffmpeg-full/x86_64/22.08 \
	org.freedesktop.Platform.openh264/x86_64/2.3.1 \
	org.xfce.mousepad

systemctl enable sddm
systemctl enable checkupdate

sudo plymouth-set-default-theme spinner
sudo systemctl set-default graphical.target 

sudo dracut -vf --regenerate-all
for user in $(users); do su -c xdg-user-dirs-update $user; done;
