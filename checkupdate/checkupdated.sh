#!/bin/bash

. /usr/local/bin/checkupdate.sh getvariables

touch "$PIPE" 2> /dev/null
chmod 666 "$PIPE"
SLEEP=7200

PIPE_MAX_LINES=100

while [[ ! "$(ping fedoraproject.org -c 1 2> /dev/null)" ]]; do
	echo "No internet connection. Retrying in 20s..."
	sleep 20
done

while true; do
	if [[ "$(wc -l $PIPE)" > "$PIPE_MAX_LINES" ]]; then
		rm "$PIPE"
		touch "$PIPE"
		chmod 666 "$PIPE"
	fi
	echo  requesting update check
	. /usr/local/bin/checkupdate.sh | tee -a "$PIPE"
	echo Sleeping for "$SLEEP" seconds
	sleep "$SLEEP"
done
