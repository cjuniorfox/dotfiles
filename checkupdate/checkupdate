#!/bin/bash
PIPE=/tmp/update.pipe
UPDATING_FILE=/tmp/updating
UPDATE_LOG=/tmp/update.log
QT_UPDATE=/tmp/qtupdate

touch "$UPDATE_LOG"
chmod 666 "$UPDATE_LOG"

if [[ "$1" == "getvariables" ]]; then
	return 0
fi;

get_values(){
	HASFLATPAK=$(flatpak --version > /dev/null 2>&1 && echo 1 || echo 0)
	printf  '%s Checking DNF updates...\n' "$(date)" | tee -a "$UPDATE_LOG" >&2
	DNF="$(dnf check-update -q | grep -v -e '^$' | wc -l)"
	printf '%s dnf updates found\n' "$DNF" | tee -a "$UPDATE_LOG" >&2
	FLATPAK=0
	if [ "$HASFLATPAK" == "1" ]; then
	printf '%s Checking flatpak updates\n' "$(date)" | tee -a "$UPDATE_LOG" >&2
		FLATPAK="$(flatpak update | grep -e [0..9]\.\ | wc -l)"
	fi;
	printf '%s flatpak updates found' "$FLATPAK" | tee -a "$UPDATE_LOG" >&2
	echo -e "DNF=$DNF\nFLATPAK=$FLATPAK\nALL=$(expr $DNF + $FLATPAK)" > "$QT_UPDATE"
	printf '%s Update checked sucessfully' "$(date)" | tee -a "$UPDATE_LOG" >&2
}


check_internet() { 
	printf '%s Checking Internet connection.\n' "$(date)" | tee -a "$UPDATE_LOG" >&2
	ping fedoraproject.org -c 1 > /dev/null 2>&1 && return 0 || return 1; 
}

if [[ -f "$UPDATING_FILE" ]]; then
	return
fi

if [[ ! check_internet ]] ; then
	echo ""
	return
fi

get_values


QT_UPDATES="$(expr $FLATPAK + $DNF )"
if [ "$QT_UPDATES" != "0" ]; then
	echo "$QT_UPDATES"
else
	echo ""
fi
