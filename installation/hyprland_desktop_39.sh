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

echo "Base packages"
dnf install -y \
	adwaita-blue-gtk-theme \
	adwaita-icon-theme \
	azote \
	blueman \
	breeze-cursor-theme \
	breeze-gtk \
	breeze-icon-theme 
	dunst \
	firewall-config \
	flatpak \
	git \
	gnome-keyring \
	gnome-packagekit-installer \
	gnome-software \
	gvfs-smb \
	htop \
	hyprland \
	ibus-panel \
	kitty \
	nautilus \
	network-manager-applet \
	pavucontrol \
        plymouth-theme-spinner \
	pulseaudio-utils \
	rofi-wayland \
	sddm \
	seahorse \
	socat \
	swaybg \
	swayidle \
	swaylock \
	polkit-gnome \
	xdg-user-dirs \
	xdg-user-dirs-gtk \
	wlr-randr

dnf remove imsettings -y

echo "Hyperland from solopasha"
dnf copr -y enable solopasha/hyprland
dnf update --refresh -y &&  install -y \
	cliphist \
	hyprshot \
        wl-clipboard

echo "Hyprland shell from cjuniorfox"
dnf copr -y enable cjuniorfox/hyprland-shell
dnf update --refresh -y && dnf install -y \
	hyprland-shell-waybar \
	rofi-shutdown-menu \
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

plymouth-set-default-theme spinner
sudo systemctl set-default graphical.target 

dracut -vf --regenerate-all
for user in $(users); do su -c xdg-user-dirs-update $user; done;
