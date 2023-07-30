name=Fedora local
baseurl=file:///home/junior/rpmbuild/RPMS/x86_64
enabled=1
gpgcheck=0

[local-noarch]
name=Fedora local noarch
baseurl=file:///home/junior/rpmbuild/RPMS/noarch
enabled=1
gpgcheck=0
EOF

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
	gvfs-smb \
	hyprland \
	hyprland-contrib \
	hyprland-plugins \
	hyprpaper \
	hyprpicker \
	hyprshot \
	htop \
	i3exit \
	kitty \
	network-manager-applet \
	pavucontrol \
	pulseaudio-utils \
	rofi-wayland \
	sddm \
	socat \
	swaybg \
	swayidle \
	swaylock \
	polkit-gnome \
	xdg-desktop-portal-hyprland \
	waybar-hyprland \
	wlr-randr \
	thunar \
	wob

flatpak remote-delete fedora && \
	flatpak remote-delete fedora-testing
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
	com.github.hluk.copyq \
	com.github.tchx84.Flatseal \
	org.gnome.Calculator \
	org.gnome.FileRoller \
	org.gnome.FontManager \
	org.mozilla.firefox \
	org.freedesktop.Platform.ffmpeg-full/x86_64/22.08 \
	org.freedesktop.Platform.openh264/x86_64/2.3.1 \
	org.xfce.mousepad

systemctl enable sddm
systemctl enable checkupdate

sudo plymouth-set-default-theme tribar -R
sudo systemctl set-default graphical.target 
