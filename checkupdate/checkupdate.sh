#!/bin/bash

PIPE=/tmp/update.pipe
CHECKUPDATES="/tmp/checkupdate"; #Check update count file
TIMEOUT=10 ; #Timeout in seconds
CURRENTTIME=$(date +%s)
UPDATING_FILE=/tmp/updating

write_check_file(){
	HASFLATPAK=$(flatpak --version > /dev/null 2>&1 && echo 1 || echo 0)
	DNF="$(dnf check-update -q 2> /dev/null | grep -v -e '^$' | wc -l)"
	FLATPAK=0
	if [ "$HASFLATPAK" == "1" ]; then
		FLATPAK="$(flatpak update 2> /dev/null | grep -e [0..9]\.\ | wc -l)"
	fi;
	rm -f "$CHECKUPDATES"
	echo "$FLATPAK" > "$CHECKUPDATES"
	echo "$DNF" >> "$CHECKUPDATES"
	chmod -R 555 "$CHECKUPDATES"
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

check_internet() { 
	ping fedoraproject.org -c 1 > /dev/null 2>&1 && return 0 || return 1; 
}

if [[ -f "$UPDATING_FILE" ]]; then
	return
fi

if  [[ ! -f "$CHECKUPDATES" ]]; then
	write_check_file
fi

FILETIME=$(stat -c '%Z' "$CHECKUPDATES")
FILEAGE="$(expr $CURRENTTIME - $FILETIME)"

if  ! check_internet ; then
	echo ""
	rm "$CHECKUPDATES"
	return
fi

if [ "$FILEAGE" -gt "$TIMEOUT" ]; then
	write_check_file
else
	get_values_from_file
fi


QT_UPDATES="$(expr $FLATPAK + $DNF )"
if [ "$QT_UPDATES" != "0" ]; then
	echo "$QT_UPDATES";
fi
