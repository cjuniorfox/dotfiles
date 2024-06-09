dnf update --refresh -y

dnf groupinstall -y \
	Administration\ Tools \
	Common\ NetworkManager\ Submodules \
	Core \
	Fonts \
	Hardware\ Support \
	Multimedia \
	Printing\ Support \
	Standard

echo "Base packages"
dnf install -y \
	adwaita-blue-gtk-theme \
	adwaita-gtk2-theme \
	adwaita-icon-theme \
	adwaita-qt5 \
	azote \
	bash-completion \
	blueman \
	breeze-cursor-theme \
	breeze-gtk \
	breeze-icon-theme \
	chrony \
	dunst \
	firewall-config \
	flatpak \
	fontawesome-6-free-fonts \
	fontawesome-6-brands-fonts \
	git \
	gnome-keyring \
	gnome-packagekit-installer \
	gnome-software \
	gvfs-smb \
	gvfs-nfs \
	htop \
	hyprland \
	ibus-panel \
	kitty \
	liberation-fonts \
	nautilus \
	network-manager-applet \
	pavucontrol \
	pulseaudio-utils \
	sddm \
	seahorse \
	socat \
	swaybg \
	swayidle \
	swaylock \
	system-config-printer \
	polkit-gnome \
	xdg-user-dirs \
	xdg-user-dirs-gtk \
	wlr-randr \
	yaru-{gtk2,gtk3,gtk4,icon,sound}-theme

#dnf remove imsettings -y

echo "Hyperland from solopasha"
dnf copr -y enable solopasha/hyprland
dnf update --refresh -y && dnf install -y \
	cliphist \
	hyprshot \
    wl-clipboard

echo "Hyprland shell from cjuniorfox"
dnf copr -y enable cjuniorfox/hyprland-shell
dnf update --refresh -y && dnf install -y \
	hyprland-shell-waybar \
	rofi-shutdown-menu \
	wol-changer
dnf swap -y rofi rofi-wayland
systemctl enable checkupdate.timer
systemctl enable chronyd
echo "Tofik/sway"
dnf copr -y enable tofik/sway
dnf update --refresh -y && dnf install -y sway-audio-idle-inhibit

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

plymouth-set-default-theme bgrt -R
systemctl set-default graphical.target 
echo 'Installing the basic user files'
git clone https://github.com/cjuniorfox/dotfiles.git
USERS=$(awk -F"[/:]" "{if (\$3 >= 1000 && \$3 != 65534) print \$1}" /etc/passwd)
for user in ${USERS}; do 
    su -c xdg-user-dirs-update $user;
    mkdir -p /home/$user/.config/{hypr,waybar,rofi}
    cp -rvp dotfiles/hypr/* /home/$user/.config/hypr
    cp -rvp dotfiles/waybar/* /home/$user/.config/waybar
    cp -rvp dotfiles/rofi/* /home/$user/.config/rofi
    touch /home/$user/.config/hypr/monitors.conf
    touch /home/$user/.config/hypr/workspaces.conf
    touch /home/$user/.config/hypr/input.conf
    chown -R $user /home/$user/.config
    su -c xdg-user-dirs-update $user;
done;
rm -rf dotfiles
