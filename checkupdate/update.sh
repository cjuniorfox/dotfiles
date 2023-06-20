#!/bin/bash

. /usr/local/bin/checkupdate.sh > /dev/null 2>&1

VAR_ALL="All - $QT_UPDATES"
VAR_FLATPAK="Flatpak - $FLATPAK"
VAR_DNF="Fedora - $DNF"

animate(){
	ANIM="|/-\\"
	while "$ANIMATE" = "true" ; do 
		for (( i=0; i<${#ANIM}; i++ )); do 
			echo "${ANIM:$i:1}" > "$PIPE";  
			sleep 0.5; 
		done; 
	done
	echo "" > "$PIPE"
}

run_flatpak(){
    touch "$UPDATING_FILE"
    ANIMATE=true animate &
    cat << EOF | bash && notify-send "Flatpak packages updated" || notify-send "There was a error updating the system"
flatpak update --noninteractive
EOF
    rm -f "$UPDATING_FILE"
    rm -f "$CHECKUPDATES"
    ANIMATE=""
    . /usr/local/bin/checkupdate.sh > /dev/null 2>&1
}

run_dnf(){
    touch "$UPDATING_FILE"
    ANIMATE=True animate &
    cat << EOF | pkexec && notify-send "System updated" || notify-send "There was a error updating the system"
dnf upgrade -y
EOF
    rm -f "$UPDATING_FILE"
    rm -f "$CHECKUPDATES"
    ANIMATE=""
    . /usr/local/bin/checkupdate.sh > /dev/null 2>&1
}

run_all(){
    touch "$UPDATING_FILE"
    ANIMATE=true animate &
    cat << EOF | pkexec && notify-send "System Updated" || notify-send "There was a error updating the system"
flatpak update --noninteractive
dnf upgrade -y
EOF
    rm -f "$UPDATING_FILE"
    rm -f "$CHECKUPDATES"
    ANIMATE=""
    . /usr/local/bin/checkupdate.sh > /dev/null 2>&1
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
