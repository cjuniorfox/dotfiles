dnf copr -y enable cjuniorfox/hyprland-shell
dnf copr -y enable solopasha/hyprland
dnf copr -y enable en4aew/desktop-tools 

dnf update --refresh -y

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
	cliphist \
	dunst \
	firewall-config \
	flatpak \
	git \
	gnome-keyring \
	gnome-packagekit-installer \
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
	wlr-randr \
	wol-changer

flatpak remote-delete fedora && \
	flatpak remote-delete fedora-testing
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
	com.github.tchx84.Flatseal \
	org.gnome.Calculator \
	org.gnome.Evince \
	org.gnome.FileRoller \
	org.gnome.FontManager \
	org.gnome.Loupe \
	org.gnome.TextEditor \
	org.mozilla.firefox \
	org.freedesktop.Platform.ffmpeg-full/x86_64/22.08 \
	org.freedesktop.Platform.openh264/x86_64/2.3.1 \

systemctl enable sddm

sudo plymouth-set-default-theme spinner
sudo systemctl set-default graphical.target 

sudo dracut -vf --regenerate-all
for user in $(users); do su -c xdg-user-dirs-update $user; done;
