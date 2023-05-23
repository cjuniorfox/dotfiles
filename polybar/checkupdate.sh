#!/bin/bash

CHECKUPDATES="/tmp/checkupdate"; #Check update count file
TIMEOUT=7200 ; #Timeout in seconds
CURRENTTIME=$(date +%s)
UPDATING_FILE=/tmp/updating

write_check_file(){
	HASFLATPAK=$(flatpak --version > /dev/null 2>&1 && echo 1 || echo 0)
	DNF="$(dnf check-update -q 2> /dev/null | grep -v -e '^$' | wc -l)"
	FLATPAK=0
	if [ "$HASFLATPAK" == "1" ]; then
		FLATPAK="$(flatpak update 2> /dev/null | grep -e [0..9]\.\ | wc -l)"
	fi;
	echo "$FLATPAK" > "$CHECKUPDATES"
	echo "$DNF" >> "$CHECKUPDATES"
}

get_values_from_file(){
	for i in $(cat "$CHECKUPDATES"); do
		if [ -z $FLATPAK ]; then
			FLATPAK="$i";
		else
			DNF="$i"
		fi
	done;
}

if [[ -f "$UPDATING_FILE" ]]; then
	echo "Updating..."
	exit 0
fi

if  [[ ! -f "$CHECKUPDATES" ]]; then
	write_check_file
fi

FILETIME=$(stat -c '%Z' "$CHECKUPDATES")
FILEAGE="$(expr $CURRENTTIME - $FILETIME)"

if [ "$FILEAGE" -gt "$TIMEOUT" ]; then
	write_check_file
else
	get_values_from_file
fi


QT_UPDATES="$(expr $FLATPAK + $DNF )"
#if [ "$QT_UPDATES" != "0" ]; then
	echo "$QT_UPDATES";
#fi
