#!/bin/bash

. ~/.config/rofi/checkupdate.sh > /dev/null 2>&1

VAR_ALL="All - $QT_UPDATES"
VAR_FLATPAK="Flatpak - $FLATPAK"
VAR_DNF="Fedora - $DNF"

run_flatpak(){
    touch "$UPDATING_FILE"
    cat << EOF | bash && notify-send "Flatpak packages updated" || notify-send "There was a error updating the system"
flatpak update --noninteractive
EOF
rm "$UPDATING_FILE"
rm "$CHECKUPDATES"
}

run_dnf(){
    touch "$UPDATING_FILE"
    cat << EOF | pkexec && notify-send "System updated" || notify-send "There was a error updating the system"
dnf upgrade -y
EOF
rm "$UPDATING_FILE"
rm "$CHECKUPDATES"
}

run_all(){
    touch "$UPDATING_FILE"
    cat << EOF | pkexec && notify-send "System Updated" || notify-send "There was a error updating the system"
flatpak update --noninteractive
dnf upgrade -y
EOF
rm "$UPDATING_FILE"
rm "$CHECKUPDATES"
}


CONF=$(cat << EOF
configuration{
        show-icons:false;
}
#window {
        y-offset: 32px;
        width: 12em;
        anchor: north east;
        location: north east;
}
mainbox {
        children: [inputbar,listview];
}
listview{
        coluns:1;
        lines:3;
}
EOF
)

case $(cat << EOF | rofi -dmenu -theme-str "$CONF" -i -p "Apply updates?"
$VAR_ALL
$VAR_DNF
$VAR_FLATPAK
EOF
) in
"$VAR_FLATPAK")
 run_flatpak;;
"$VAR_DNF")
 run_dnf;;
"$VAR_ALL")
 run_all;;
esac
