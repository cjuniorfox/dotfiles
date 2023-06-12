#!/bin/sh

BEFORE=""; 
while true ; do
	PROP="$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW 2>/dev/null | cut -f 2)"
	if [[ "$PROP" != "0x0" && "$PROP" != "" ]] ; then
		CLOSE="$1";
	else
		CLOSE="";
	fi
	if [[  "$CLOSE" != "$BEFORE" ]]; then 
		BEFORE="$CLOSE"; 
		echo "$CLOSE"; 
	fi;   
	sleep 0.05; 
done
