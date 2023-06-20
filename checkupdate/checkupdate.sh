#!/bin/bash
PIPE=/tmp/update.pipe
UPDATING_FILE=/tmp/updating
UPDATE_LOG=/tmp/update.log

touch "$UPDATE_LOG"
chmod 660 "$UPDATE_LOG"

if [[ "$1" == "getvariables" ]]; then
	return 0
fi;

get_values(){
	HASFLATPAK=$(flatpak --version > /dev/null 2>&1 && echo 1 || echo 0)
	echo "$(date)" Checking DNF updates... >> "$UPDATE_LOG"
	DNF="$(dnf check-update -q | grep -v -e '^$' | wc -l)"
	FLATPAK=0
	if [ "$HASFLATPAK" == "1" ]; then
	echo "$(date)" Checking flatpak updates >> "$UPDATE_LOG"
		FLATPAK="$(flatpak update | grep -e [0..9]\.\ | wc -l)"
	fi;
	echo  "$(date)" "Update checked sucessfully" >> "$UPDATE_LOG"
}


check_internet() { 
	echo "$(date)" Checking Internet connection. >> "$UPDATE_LOG"
	ping fedoraproject.org -c 1 > /dev/null 2>&1 && return 0 || return 1; 
}

if [[ -f "$UPDATING_FILE" ]]; then
	return
fi

echo "$(date)" "Checking updates..." >> "$UPDATE_LOG"



if [[ ! check_internet ]] ; then
	echo ""
	return
fi

get_values


QT_UPDATES="$(expr $FLATPAK + $DNF )"
if [ "$QT_UPDATES" != "0" ]; then
	echo "$QT_UPDATES";
fi
