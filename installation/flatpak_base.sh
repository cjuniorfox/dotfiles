NVIDIA=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader --id=0 | sed 's/\./-/g')
flatpak install  \
com.bitwarden.desktop \
com.github.tchx84.Flatseal \
com.leinardi.gwe \
org.freedesktop.Platform.ffmpeg-full/x86_64/22.08 \
org.freedesktop.Platform.ffmpeg_full.i386/x86_64/22.08 \
org.freedesktop.Platform.openh264/x86_64/2.3.1 \
org.gnome.Calculator \
org.gnome.Evince \
org.gnome.FileRoller \
org.gnome.FontManager \
org.gnome.Loupe \
org.gnome.Loupe.HEIC \
org.gnome.TextEditor \
org.gnome.meld \
org.mozilla.firefox
