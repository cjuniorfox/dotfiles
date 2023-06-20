#!/bin/bash

. /usr/local/bin/checkupdate.sh getvariables


animate(){
	ANIM="|/-\\"
	while [[ -f "$UPDATING_FILE" ]] ; do 
		for (( i=0; i<${#ANIM}; i++ )); do 
            if [[ -f "$UPDATING_FILE" ]]; then
			    echo "${ANIM:$i:1}" >> "$PIPE";  
            fi
			sleep 0.5; 
		done; 
	done
}

run_flatpak(){
    touch "$UPDATING_FILE"
    echo -e "$(date) Starting Flatpak update\n" | tee -a "$UPDATE_LOG"
    animate &
    cat << EOF | bash >> "$UPDATE_LOG" && notify-send "Flatpak packages updated" || notify-send "There was a error updating the system"
flatpak update --noninteractive
EOF
    rm -f "$UPDATING_FILE" && \
        . /usr/local/bin/checkupdate.sh | tee -a "$PIPE"
}

run_dnf(){
    touch "$UPDATING_FILE"
    echo -e "$(date) Starting Fedora DNF update\n" | tee -a "$UPDATE_LOG"
    animate &
    cat << EOF | pkexec >> "$UPDATE_LOG" && notify-send "System updated" || notify-send "There was a error updating the system"
dnf upgrade -y 
EOF
    rm -f "$UPDATING_FILE" && \
        . /usr/local/bin/checkupdate.sh | tee -a "$PIPE"
}

run_all(){
    touch "$UPDATING_FILE"
    echo -e "$(date) Starting Update...\n" | tee -a "$UPDATE_LOG"
    animate &
    cat << EOF | pkexec >> "$UPDATE_LOG" && notify-send "System Updated" || notify-send "There was a error updating the system"
flatpak update --noninteractive
dnf upgrade -y
EOF
    rm -f "$UPDATING_FILE" && \
        . /usr/local/bin/checkupdate.sh | tee -a "$PIPE"
}

if [[ -f "$UPDATING_FILE" ]]; then
    i3-sensible-terminal -e tail -f "$UPDATE_LOG"
	exit
fi

. /usr/local/bin/checkupdate.sh >> "$PIPE"

VAR_ALL="All - $QT_UPDATES"
VAR_FLATPAK="Flatpak - $FLATPAK"
VAR_DNF="Fedora - $DNF"

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
